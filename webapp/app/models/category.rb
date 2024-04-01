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

    def fancy_name
      name.gsub(' ', '_')
    end

    # foxnews/bleh/blah -> blah
    # 3a578ac2-6ecc-54d0-b9af-f6385da34ec6
    # 8971ddb7-f8b8-5ddf-bd90-af94a16574af
    # Fox News ugly categories..
    def cleaned_up
      uuid_regex = /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
      return "🦊news💩" if self.name =~ uuid_regex
      self.name.split("/")[-1] # last after slash
    end

    def emoji
      Category.emoji
    end

    def self.emoji
      '🏷️'
    end
end
