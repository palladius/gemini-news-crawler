class ArticleTag < ApplicationRecord
  # belongs_to :article
  # belongs_to :category

  belongs_to :article,
    primary_key: :id,
    foreign_key: :article_id,
    class_name: 'Article'

  belongs_to :category,
    primary_key: :id,
    foreign_key: :category_id,
    class_name: 'Category'

  def to_s
    "AT(#{self.article_id};#{self.category_id})"
  end
end
