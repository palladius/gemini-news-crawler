# Adds PgVector extension. See
# https://stackoverflow.com/questions/16611226/how-to-install-postgres-extensions-at-database-creation
class AddPgVectorExtension < ActiveRecord::Migration[7.1]
  def change
    # "CREATE EXTENSION vector;"
    enable_extension "vector"
    # Or: same thing:
    # execute <<-SQL
    #     CREATE EXTENSION IF NOT EXISTS vector;
    # SQL

    # Create a table
    # CREATE TABLE items (id bigserial PRIMARY KEY, embedding vector(3));
    # create_table :embeddings do |t|
    #   t.references :article, null: false, foreign_key: true
    #   t.references :category, null: false, foreign_key: true
    #   t.text :ricc_internal_notes

    #   t.timestamps
    # end
  end
end
