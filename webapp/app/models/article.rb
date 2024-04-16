class Article < ApplicationRecord
  include Embeddable

  validates :title, uniqueness: true, presence: true
  validates :guid, uniqueness: true

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
  after_save :set_defaults_after

    # https://stackoverflow.com/questions/5164566/how-to-intercept-assignment-to-attributes
    def categories=(categories)
      method_ver = '0.2'
      raise "I only accept an Array of Strings!" unless categories.is_a? Array
      #Rails.logger.info "Setting categories with #{categories}"
      #puts "Setting categories with #{categories}"

      write_attribute :ricc_internal_notes, categories
      #write_attribute :username, username
      @categories_to_be_initialized = []
      categories.each do |category_name|
        c = Category.find_or_create_by(name: category_name)
        puts("#{Category.emoji}  Category created or found: #{c} (id=#{c.id})")
        @categories_to_be_initialized << c
      end
      puts "Setting categories with #{categories}"
    end

    def set_categories()
      puts("I just initialized my object. Now I have an id and can finally create the AT I need")
      puts("@categories_to_be_initialized: #{@categories_to_be_initialized}")
      puts "Now i have an id: #{self.id} - anzi no"
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
      puts("Article::set_defaults (before_save). My id=#{self.id}")
      self.active ||= true
#      self.author ||= 'Cielcio Conti'
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
      published_date.localtime.to_s[0,10]
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
  end
