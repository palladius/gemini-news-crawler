class ArticleTag < ApplicationRecord
  belongs_to :article_id
  belongs_to :category_id
end
