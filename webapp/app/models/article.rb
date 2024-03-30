class Article < ApplicationRecord
  # has_many :categories,
  #   primary_key: :id,
  #   foreign_key: :category_id,
  #   class_name: 'ArticleTag'

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
      raise "I only accept an Array of Strings!" unless categories.is_a? Array
      Rails.logger.info "Setting categories with #{categories}"
      puts "Setting categories with #{categories}"
      #puts('TODO craete')
      #write_attribute :username, username
      categories.each do |category_name|
        c = Category.find_or_create_by(name: category_name)
        #categories << c
      end
      puts "Setting categories with #{categories}"
    end

  end
