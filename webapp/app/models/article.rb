class Article < ApplicationRecord
  # has_many :categories,
  #   primary_key: :id,
  #   foreign_key: :category_id,
  #   class_name: 'ArticleTag'
  validates :title, uniqueness: true

  has_many :article_tags,
    primary_key: :id,
    foreign_key: :article_id,
    class_name: 'ArticleTag'

  has_many :categories,
    through: :article_tags,
    source: :category
  # has_many :articles,
  #   through: :article_tags,
  #   source: :article

    # https://stackoverflow.com/questions/5164566/how-to-intercept-assignment-to-attributes
    def categories=(categories)
      method_ver = '0.2'
      raise "I only accept an Array of Strings!" unless categories.is_a? Array
      Rails.logger.info "Setting categories with #{categories}"
      puts "Setting categories with #{categories}"
      #puts('TODO craete')
      #write_attribute :username, username
      categories.each do |category_name|
        c = Category.find_or_create_by(name: category_name)
        #categories << c
        ArticleTag.find_or_create_by(
          article_id: self.id,
          category_id: c.id,
          ricc_internal_notes: "Created during Article creation via categories=() method v#{method_ver}.",
        )
      end
      puts "Setting categories with #{categories}"
    end

  end
