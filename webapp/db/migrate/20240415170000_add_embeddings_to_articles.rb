class AddEmbeddingsToArticles < ActiveRecord::Migration[7.1]
  def change
    # https://apidock.com/rails/ActiveRecord/ConnectionAdapters/SchemaStatements/add_column
    add_column :articles, :title_embedding, :float, array: true
    add_column :articles, :summary_embedding, :float, array: true # null: true - but I love null here.
  end
end
