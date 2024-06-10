# frozen_string_literal: true

class CreateArticleTags < ActiveRecord::Migration[7.1]
  def change
    create_table :article_tags do |t|
      t.references :article, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.text :ricc_internal_notes

      t.timestamps
    end
  end
end
