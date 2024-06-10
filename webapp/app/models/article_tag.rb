# frozen_string_literal: true

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
    "AT(#{article_id};#{category_id})"
  end

  def category_name
    # Article.find(10259).article_tags.first.
    category.name
  end
end
