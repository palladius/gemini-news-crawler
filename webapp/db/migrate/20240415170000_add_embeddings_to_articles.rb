# frozen_string_literal: true

class AddEmbeddingsToArticles < ActiveRecord::Migration[7.1]
  def change
    # https://apidock.com/rails/ActiveRecord/ConnectionAdapters/SchemaStatements/add_column
    # add_column :articles, :title_embedding, :float, array: true
    # add_column :articles, :summary_embedding, :float, array: true # null: true - but I love null here.
    # Seems wrong! SHould be vector
    enable_extension 'vector'
    add_column :articles, :title_embedding, :vector, limit: 768 # dimensions
    add_column :articles, :summary_embedding, :vector, limit: 768 # dimensions
    # As per https://github.com/ankane/neighbor:
    # add_column :items, :embedding, :vector, limit: 3 # dimensions
  end
end
