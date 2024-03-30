class Category < ApplicationRecord
  has_many :article_tags,
  primary_key: :id,
  foreign_key: :category_id,
  class_name: 'ArticleTag'

has_many :articles,
  through: :article_tags,
  source: :article

end
