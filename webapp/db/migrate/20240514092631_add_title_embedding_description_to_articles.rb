# frozen_string_literal: true

class AddTitleEmbeddingDescriptionToArticles < ActiveRecord::Migration[7.1]
  def change
    # Adding a Hash of information:Gemini vs OpenAI, how i calculated, and so on...
    add_column :articles, :title_embedding_description, :text
    add_column :articles, :article_embedding_description, :text
    add_column :articles, :summary_embedding_description, :text
  end
end
