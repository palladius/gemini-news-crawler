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

  # https://stackoverflow.com/questions/17466903/set-default-value-on-empty-text-field
  # before_save :set_author_and_content
  # def set_author_and_content
  #   self.author = 'Cielcio Conti' if self.author.blank?
  #   self.content = 'empty' if self.content.blank?
  # end

  # WRONG! BUG!
  # # Ma se lo tolgo non va: missing attribute 'author' for Article
  # # this works!
  def content_safe = content rescue 'empty'

  def author_safe = author rescue 'Cielcio Conti'
  def author = super.presence or 'Cielcio Conti' rescue '[no author]'
  def content = super.presence || 'empty' rescue '[no content]'
    # this doesnt work
  #def author =     @author || 'Cielcio Conti'
  #def content =    @content || 'empty'

  def set_defaults_after
    puts("Article::set_defaults_after (after_save). My id=#{id}")
    # self.active ||= true
    # self.
    #@author ||= 'Cielcio Conti'
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
      ret += "[content]\n#{content.strip}\n[/content]\n\n" unless content.blank?
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
    #ret += "[content]\n#{content.strip.first(200)}\n[/content]\n\n" if content?
    ret += ("\n[content]\n#{content.strip.first(200)}\n[/content]\n\n" rescue '')
    # Footer
    #ret += "Author: #{author}\n" if author?
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


  # FROM: \\342\\200\\234Un ritorno di fiamma tra Fedez e Ferragni? Vi dico la verit\303\240\\342\\200\\235: l\\342\\200\\231esperta di gossip Marzano svela uno scambio di messaggi con l\\342\\200\\231imprenditrice digitale
  # TO: “Un ritorno di fiamma tra Fedez e Ferragni? Vi dico la verità”: l’esperta di gossip Marzano svela uno scambio di messaggi con l’imprenditrice digitale
  # https://stackoverflow.com/questions/2812781/how-to-convert-webpage-apostrophe-8217-to-ascii-39-in-ruby-1-8-7#comment2853475_2812781
  def self.fix_andrei_newspaper_weird_characters(str, remove_all_double_slashes: false)
    # changes e', i', \\, \', \r , ’ ‘

    str.
        gsub('\\303\\240', 'à'). # aeiou accentate
        gsub('\\303\\251', 'é').gsub('\\303\\250', 'è'). # e
        gsub('\\303\\255', 'í').gsub('\\303\\254', 'ì'). # i acuto e grave
        gsub('\\303\\271', 'ù').  # u
      gsub('\\302\\253', '«').gsub('\\302\\273', '»').gsub('\\342\\200\\231','’').gsub('\\342\\200\\230',"‘").            # single quotes
      gsub('\\342\\200\\234',"“").gsub('\\342\\200\\235',"”").gsub('\\342\\200\\231',"’").gsub('\\\\342\\\\200\\\\231',"’"). # double quotes
      gsub("\\342\\200\\224"," — ").gsub("\\342\\200\\246","..."). # dashes \\\n \342\200\246 i dont know!!! I believe its three dots
      gsub("\\\\\\\\n","\n"). #  4 \\\n always MORE then fewer
      gsub("\\\\\\n","\n"). #  3 \\\n
      gsub("\\\\n","\n"). #  3 \\\n
      gsub('\\\\\\"','"').gsub('\\\\"','"').gsub('\\"','"'). #  3,2,1 \\\" Apici doppi (uso singoli per tenerli dentro)
      gsub("\\\\\\'","'").gsub("\\\\'","'").gsub("\\'","'"). #  3,2,1 \\\" Apici singoli (uso doppi per tenerli)
      gsub("\\r",'')
    #str.gsub('\\','') if remove_all_double_slashes # quando lo esegui e' distruttivo, toglilo in DEBUG...
    #str
  end
  # Le Vibrazioni, è morta Giulia Tagliapietra, protagonista della canzone (e del video) «Dedicato a te»
  #def modify = .gsub('\\303\\250', 'è').gsub('\\303\\255', 'í').gsub('\\302\\253', '«').gsub('\\302\\273', '»')

  #=> "\\\\\\\"Ciao amici, sono Gerardina Trovato. A casa. Io ho sempre pensato che quello che conta è la gente. E noi non saremmo niente se non ci foste voi. Non mi abbandonate. Diventate sempre di più, perché voi siete la mia forza\\\\\\\". (ANSA)"
  def cleanup_ugly_backslashes
    self.summary = Article.fix_andrei_newspaper_weird_characters(self.summary, remove_all_double_slashes: false)
    self.content = Article.fix_andrei_newspaper_weird_characters(self.content, remove_all_double_slashes: false)
    self.title = Article.fix_andrei_newspaper_weird_characters(self.title, remove_all_double_slashes: false)

    puts("cleanup_ugly_backslashes() finished, now saving!")
    self.save
  end

  def fix_ugly_bckslashes = cleanup_ugly_backslashes # lazy alias

  # removes the 3 embeddings, and adds llm_info
  # "title_embedding",
  # "summary_embedding",
  # "article_embedding",
  def cleaned_up
    #require 'active_support/core_ext/hash'
    h = self.as_json
    h[:llm_info] = llm_info
    h.except('title_embedding').except('summary_embedding').except('article_embedding').except('hidden_blurb') # .except('llm_info')
  end

  # Just stuff that GenAI might be interested in reading..
  def minimalistic_json
    self.cleaned_up.except('title_embedding_description').except('ricc_internal_notes').except('article_embedding_description').except(:llm_info).except('summary_embedding_description')
  end

  def llm_info
    # on 9octy i started indexing manually TWO articles in dev.
    # this is bad as their distnaces are now screwed up:
    # id=889
    # id=10439
    article_class13 = title_embedding_description.nil? ?
      'v1 (like 99% of articles)' :
      'v3 (very few articles updated on 9oct24)'
    [
      "[v2] article_embedding_description: #{article_embedding_description}",
      "[v1/3] title_embedding_description: #{title_embedding_description}",
      "[v1/3] summary_embedding_description: #{summary_embedding_description}",
      "As per bug https://github.com/palladius/gemini-news-crawler/issues/4 we can state this article belongs to titile/summary version: #{article_class13}"
  ]

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


  def self.last24hours
    #now =  Time.now
    Article.where(created_at: (Time.now - 24.hours)..Time.now)
  end
end
