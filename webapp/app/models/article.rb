# frozen_string_literal: true

class Article < ApplicationRecord
  include Embeddable

  # Note wwe also have a :title_embedding_description
  @@title_embedding_meaning = '[768 array][OLD yet productive] This is the embedding used. Its computed with an old algorithm nd its only compatiblwe with THAT algorithm. This distance is used to calculate distance across articles in demo1 and in the article view. Im not 100% sure but I believe it uses Google multilang embedding model'
  @@summary_embedding_meaning = '[768 array] I believe this is NOT utilized 🏧'
  @@article_embedding_meaning = '[768 array] I believe it uses Google single-lamnguage strongest newest model.'

  # https://stackoverflow.com/questions/39753594/how-do-i-access-class-variable
  # class << self
  #   attr_accessor  :summary_embedding, :article_embedding_meaning
  # end
  # Convenience method: https://apidock.com/rails/Module/mattr_accessor
  mattr_accessor :title_embedding_meaning, :summary_embedding_meaning, :article_embedding_meaning

  # https://github.com/ankane/neighbor
  has_neighbors :article_embedding
  has_neighbors :title_embedding
  has_neighbors :summary_embedding

  validates :title, uniqueness: true, presence: true
  validates :guid, uniqueness: true, presence: true
  # published_date
  validates :published_date, presence: true # We really want this data..

  # Trying to fix the String bug for title_embedding - thanks Gemini!
  # attribute :title_embedding, :float, array: true
  # attribute :title_embedding, :vector, limit: 768
  #     add_column :articles, :title_embedding, :vector, limit: 768 # dimensions

  # https://stackoverflow.com/questions/5947214/howto-model-scope-for-todays-records
  # Only recent articles
  # scope :recent_enough, -> { where("? BETWEEN startDate AND endDate", Time.now.to_date)}
  # created_at
  #  scope :recent_enough, lambda { WHERE('DATE(created_at) = ?', Date.today)}
  scope :within_date, lambda { |date|
                        { conditions: ['created_at >= ? AND created_at <= ?', date.beginning_of_day, date.end_of_day] }
                      }
  scope :recent_enough_by_date, ->(date) { { conditions: ['created_at >= ?', date.beginning_of_day] } }
  # scope :recent_enough, lambda { {:conditions => ['created_at >= ?', Date.yesterday.beginning_of_day]}}
  scope :recent_enough, -> { where('created_at > ?', Date.yesterday.beginning_of_day) }
  # sneisble (sensato): Anythign that makes sense. For instance, if you have no macro egion youre notr probably worth reading.
  scope :sensible, -> { where.not('macro_region' => nil) }
  scope :select_sensible_columns, lambda {
                                    # This needs to be FAST enough but also remove all SLOW stuff like HUGE embeddings
                                    select(:id, :title, :macro_region, :created_at, :published_date, :guid, :summary, :link, :newspaper)
                                  }

  has_many :article_tags,
           primary_key: :id,
           foreign_key: :article_id,
           class_name: 'ArticleTag',
           dependent: :delete_all

  has_many :categories,
           through: :article_tags,
           source: :category,
           dependent: :delete_all

  # https://stackoverflow.com/questions/18232623/create-related-objects-after-initialize-another-object-in-rails
  # after_initialize :set_categories
  before_save :set_categories
  before_save :set_defaults
  before_save :set_embeddings_best_effort
  after_save :set_defaults_after

  # https://stackoverflow.com/questions/5164566/how-to-intercept-assignment-to-attributes
  def categories=(categories, verbose: false)
    raise 'I only accept an Array of Strings!' unless categories.is_a? Array

    # Rails.logger.info "Setting categories with #{categories}"
    # puts "Setting categories with #{categories}"

    write_attribute :ricc_internal_notes, categories
    # write_attribute :username, username
    @categories_to_be_initialized = []
    categories.each do |category_name|
      c = Category.find_or_create_by(name: category_name)
      puts("#{Category.emoji}  Category created or found: #{c} (id=#{c.id})") if verbose
      @categories_to_be_initialized << c
    end
    puts "Setting categories with #{categories}" if verbose
  end

  # This is usually called BEFORE its saved, so you have no ID.
  def set_categories
    # puts("I just initialized my object. Now I have an id and can finally create the AT I need")
    puts("@categories_to_be_initialized: #{@categories_to_be_initialized}")
    # puts "Now i have an id: #{self.id} - anzi no"
    # @categories_to_be_initialized.each do |c|
    #   at = ArticleTag.find_or_create_by(
    #       article_id: self.id,
    #       category_id: c.id,
    #       ricc_internal_notes: "Created during Article creation via set_categories() method.",
    #     )
    #   puts("🦄 AT(sc) Created: #{at}")
    # end
  end

  # testing deconstruct_keys - never used before. from lucian ghinda
  # def  deconstruct_keys
  #   42
  # end

  # much better!
  def interesting_attributes
    attributes.except('title_embedding', 'summary_embedding', 'article_embedding',
                      # other boring stuff
                      'ricc_internal_notes', 'hidden_blurb', 'guid',
                      'article_embedding_description', 'title_embedding_description', 'summary_embedding_description')
  end

  def set_defaults
    # puts("Article::set_defaults (before_save). My id=#{self.id}")
    self.active ||= true
  end

  def author_or_newspaper
    return author if author.to_s.length > 3

    newspaper
  end

  def set_defaults_after
    puts("Article::set_defaults_after (after_save). My id=#{id}")
    # self.active ||= true
    # self.author ||= 'Cielcio Conti'
    @categories_to_be_initialized ||= []
    @categories_to_be_initialized.each do |c|
      at = ArticleTag.find_or_create_by(
        article_id: id,
        category_id: c.id,
        ricc_internal_notes: 'Created during Article creation via set_categories() method.'
      )
      puts("🦄 AT(sc) Created: #{at}")
    end
  end

  def yyyymmdd
    published_date.localtime.to_s[0, 10]
  rescue StandardError
    ''
  end

  def yyyymmdd_hhmm
    published_date.localtime.to_s[0, 16]
  rescue StandardError
    ''
  end

  def hhmm
    published_date.localtime.to_s[11, 5]
  rescue StandardError
    ''
  end

  # get a lot of errors in prod for empty/nil values...
  def published_date
    default_value = Time.zone.at(1970) # 1970-01-01
    super || default_value
  end

  def to_s
    "#{Article.emoji} #{title}"
  end

  def self.emoji
    '🗞️'
  end

  def url
    link
  end

  # item.nearest_neighbors(:embedding, distance: "euclidean").first(5)
  # https://github.com/ankane/neighbor
  # def closest_articles(size: 6)
  #   self.nearest_neighbors(:article_embedding, distance: "euclidean").first(size)
  #   #self.nearest_neighbors(:title_embedding, distance: "euclidean").first(size)
  # end

  def closest_articles(size: 5, similarity_field: :title_embedding)
    distance_type = 'cosine' # cosine, euclidean
    raise "Unknown similarity field: #{similarity_field}" unless similarity_field.is_a?(Symbol)

    nearest_neighbors(similarity_field, distance: distance_type).first(size)
    # Also works:
    # self.nearest_neighbors(:article_embedding, distance: "euclidean").first(size)
    # self.nearest_neighbors(:title_embedding, distance: "euclidean").first(size)
  end

  def set_embeddings_best_effort
    puts('Article before_save(): set_embeddings_best_effort()')
    begin
      compute_embeddings
    rescue StandardError
      nil
    end
  end

  def tag_names
    article_tags.map(&:category_name)
  end

  # This should be the stuff you feed to the EMBEDDING
  # Note this is just because then you have a correspondance between:
  # * title -> title_embedding
  # * summary -> summary_embedding
  # * article(*) -> article_embedding
  # (*) This was the ONLY one missing, som fixing it now.
  def article(verbose: true)
    # return article_json() # testing UI..
    ret = "------------------------------\n"
    if verbose
      # Relevant info
      ret += "Title: #{title.strip}\n" if title?
      ret += "Summary: #{summary.strip}\n\n" if summary?
      # gsub!(/\n+/, '')
      ret += "[content]\n#{content.strip}\n[/content]\n\n" if content?
      # Footer
      ret += "Author: #{author}\n" if author?
      ret += begin
        "PublishedDate: #{yyyymmdd}\n"
      rescue StandardError
        nil
      end
      ret += "Category: #{macro_region}\n" # always true
      ret += "NewsPaper: #{newspaper}\n" # always true
      ret += "Tags: #{tag_names.join(', ')}\n" if tag_names.size.positive? # always true
    else
      ret += "## #{title}\n\n#{summary}\n#{content}\n-- #{newspaper}"
    end
    ret
  end

  def excerpt_for_llm
    # similar to article but shortening the content.
    ret = "------------------------------\n"
    # Relevant info
    ret += "Title: #{title.strip}\n" if title?
    ret += "Summary: #{summary.strip}\n\n" if summary?
    # gsub!(/\n+/, '')
    ret += "[content]\n#{content.strip.first(200)}\n[/content]\n\n" if content?
    # Footer
    ret += "Author: #{author}\n" if author?
    ret += begin
      "PublishedDate: #{yyyymmdd}\n"
    rescue StandardError
      nil
    end
    ret += "Category: #{macro_region}\n" # always true
    ret += "NewsPaper: #{newspaper}\n" # always true
    ret += "Tags: #{tag_names.join(', ')}\n" if tag_names.size.positive? # always true
    ret
  end

  # json or hash?
  # Hash: this code
  # JSON: article_json = article.as_json(only: [:title, :summary])
  def article_json
    # self.attributes.slice('title', 'summary', :category)
    relevant_columns = %w[title summary content category newspaper macro_region yyyymmdd] # published_date
    attributes.slice(*relevant_columns)
  end

  def fancy_neighbor_distance
    if neighbor_distance.nil?
      nil
    else
      (neighbor_distance * 100).round(2)
    end
  end

  # a.article_embedding =  a.title_embedding
  # This is a migration script I created to migrate the Title Embedding into the article embedding.
  # Why?
  # Because the title/summary embeddings i've created as ARRAYs (thanks Gemini!) and instead I need
  # to use the VECTOR() construct from pgvector. This, together with the neighbor gem, provides everything
  # I need for fast computation of nearest neighbor.
  def self.import_title_embedding_into_article_embedding
    Article.all.first(10_000).each do |a|
      # Note Bug with title_embedding.
      if a.article_embedding.nil? && !a.title_embedding.nil?
        a.article_embedding = a.title_embedding
        a.save
      end
    end
  end
end
