class Category < ApplicationRecord
  validates :name, uniqueness: true
  has_many :article_tags,
    primary_key: :id,
    foreign_key: :category_id,
    class_name: 'ArticleTag'

  has_many :articles,
    through: :article_tags,
    source: :article

  #  has_many :articles, :through => :article_tags, :source => <name>'


    def to_s
      self.name
    end

    def emoji
      Category.emoji
    end

    def self.emoji
      '🏷️'
    end
end
