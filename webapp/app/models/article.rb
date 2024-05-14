class Article < ApplicationRecord
  include Embeddable

  # https://github.com/ankane/neighbor
  has_neighbors :article_embedding
  has_neighbors :title_embedding
  has_neighbors :summary_embedding

  validates :title, uniqueness: true, presence: true
  validates :guid, uniqueness: true, presence: true
  # published_date
  validates :published_date, presence: true # We really want this data..


  # Trying to fix the String bug for title_embedding - thanks Gemini!
  #attribute :title_embedding, :float, array: true
  #attribute :title_embedding, :vector, limit: 768
  #     add_column :articles, :title_embedding, :vector, limit: 768 # dimensions

  # https://stackoverflow.com/questions/5947214/howto-model-scope-for-todays-records
  # Only recent articles
  #scope :recent_enough, -> { where("? BETWEEN startDate AND endDate", Time.now.to_date)}
  #created_at
#  scope :recent_enough, lambda { WHERE('DATE(created_at) = ?', Date.today)}
  scope :within_date, lambda {|date| {:conditions => ['created_at >= ? AND created_at <= ?', date.beginning_of_day, date.end_of_day]}}
  scope :recent_enough_by_date, lambda {|date| {:conditions => ['created_at >= ?', date.beginning_of_day]}}
  #scope :recent_enough, lambda { {:conditions => ['created_at >= ?', Date.yesterday.beginning_of_day]}}
  scope :recent_enough, -> { where("created_at > ?", Date.yesterday.beginning_of_day) }



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
  #after_initialize :set_categories
  before_save :set_categories
  before_save :set_defaults
  before_save :set_embeddings_best_effort
  after_save :set_defaults_after

    # https://stackoverflow.com/questions/5164566/how-to-intercept-assignment-to-attributes
    def categories=(categories, verbose: false)
      method_ver = '0.2'
      raise "I only accept an Array of Strings!" unless categories.is_a? Array
      #Rails.logger.info "Setting categories with #{categories}"
      #puts "Setting categories with #{categories}"

      write_attribute :ricc_internal_notes, categories
      #write_attribute :username, username
      @categories_to_be_initialized = []
      categories.each do |category_name|
        c = Category.find_or_create_by(name: category_name)
        puts("#{Category.emoji}  Category created or found: #{c} (id=#{c.id})") if verbose
        @categories_to_be_initialized << c
      end
      puts "Setting categories with #{categories}" if verbose
    end

    # This is usually called BEFORE its saved, so you have no ID.
    def set_categories()
      #puts("I just initialized my object. Now I have an id and can finally create the AT I need")
      puts("@categories_to_be_initialized: #{@categories_to_be_initialized}")
      #puts "Now i have an id: #{self.id} - anzi no"
      # @categories_to_be_initialized.each do |c|
      #   at = ArticleTag.find_or_create_by(
      #       article_id: self.id,
      #       category_id: c.id,
      #       ricc_internal_notes: "Created during Article creation via set_categories() method.",
      #     )
      #   puts("🦄 AT(sc) Created: #{at}")
      #end
    end

    def set_defaults
      #puts("Article::set_defaults (before_save). My id=#{self.id}")
      self.active ||= true
    end

    def author_or_newspaper
      return author if author.to_s.length > 3
      return newspaper
    end

    def set_defaults_after
      puts("Article::set_defaults_after (after_save). My id=#{self.id}")
      #self.active ||= true
      #self.author ||= 'Cielcio Conti'
      @categories_to_be_initialized ||= []
      @categories_to_be_initialized.each do |c|
        at = ArticleTag.find_or_create_by(
            article_id: self.id,
            category_id: c.id,
            ricc_internal_notes: "Created during Article creation via set_categories() method.",
          )
        puts("🦄 AT(sc) Created: #{at}")
      end
    end

    def yyyymmdd
      published_date.localtime.to_s[0,10] # rescue ''
    end
    def yyyymmdd_hhmm
      published_date.localtime.to_s[0,16]
    end
    def hhmm
      published_date.localtime.to_s[11,5]
    end

    def to_s
      "#{Article.emoji} #{title}"
    end

    def self.emoji
      '🗞️'
    end

    # item.nearest_neighbors(:embedding, distance: "euclidean").first(5)
    # https://github.com/ankane/neighbor
    # def closest_articles(size: 6)
    #   self.nearest_neighbors(:article_embedding, distance: "euclidean").first(size)
    #   #self.nearest_neighbors(:title_embedding, distance: "euclidean").first(size)
    # end


    def closest_articles(size: 5, similarity_field: :title_embedding)
      # :title_embedding
      # TODO make sure its title/article/whatevs
      distance_type = 'cosine' # cosine, euclidean
      raise "Unknown similarity field: #{similarity_field}" unless similarity_field.is_a?(Symbol)
      self.nearest_neighbors(similarity_field, distance: distance_type).first(size)
      #self.nearest_neighbors(:article_embedding, distance: "euclidean").first(size)
      #self.nearest_neighbors(:title_embedding, distance: "euclidean").first(size)
    end

    def set_embeddings_best_effort()
      puts("Article before_save(): set_embeddings_best_effort()")
      compute_embeddings rescue nil
    end

    def tag_names
      self.article_tags.map{|t| t.category_name }
    end

    # This should be the stuff you feed to the EMBEDDING
    # Note this is just because then you have a correspondance between:
    # * title -> title_embedding
    # * summary -> summary_embedding
    # * article(*) -> article_embedding
    # (*) This was the ONLY one missing, som fixing it now.
    def article(verbose: true)
      #return article_json() # testing UI..
      ret = "------------------------------\n"
      if verbose
        # Relevant info
        ret += "Title: #{self.title.strip}\n" if title?
        ret += "Summary: #{self.summary.strip}\n\n" if summary?
        # gsub!(/\n+/, '')
        ret += "[content]\n#{self.content.strip}\n[/content]\n\n" if self.content?
        # Footer
        ret += "Author: #{self.author}\n" if author?
        ret += "PublishedDate: #{self.yyyymmdd}\n" rescue nil
        ret += "Category: #{self.macro_region}\n" # always true
        ret += "NewsPaper: #{self.newspaper}\n" # always true
        ret += "Tags: #{self.tag_names.join(', ')}\n" if self.tag_names.size > 0  # always true
      else
        ret += "## #{self.title}\n\n#{self.summary}\n#{self.content}\n-- #{self.newspaper}"
      end
      ret
    end

    # json or hash?
    # Hash: this code
    # JSON: article_json = article.as_json(only: [:title, :summary])
    def article_json
      #self.attributes.slice('title', 'summary', :category)
      relevant_columns = %w{title summary content category newspaper macro_region yyyymmdd } # published_date
      attributes.slice(*relevant_columns)
    end

    # a.article_embedding =  a.title_embedding
    # This is a migration script I created to migrate the Title Embedding into the article embedding.
    # Why?
    # Because the title/summary embeddings i've created as ARRAYs (thanks Gemini!) and instead I need
    # to use the VECTOR() construct from pgvector. This, together with the neighbor gem, provides everything
    # I need for fast computation of nearest neighbor.
    def self.import_title_embedding_into_article_embedding()
      Article.all.first(10000).each do |a|
        # Note Bug with title_embedding.
        if a.article_embedding.nil? and (not a.title_embedding.nil?)
          a.article_embedding = a.title_embedding
          a.save
        end
      end
    end
  end
