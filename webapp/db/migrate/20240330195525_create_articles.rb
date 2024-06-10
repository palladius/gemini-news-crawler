# frozen_string_literal: true

class CreateArticles < ActiveRecord::Migration[7.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :summary
      t.text :content
      t.string :author
      t.string :link
      t.datetime :published_date
      t.string :image_url
      t.string :feed_url
      t.string :guid
      t.text :hidden_blurb
      t.string :language
      t.boolean :active
      t.text :ricc_internal_notes
      t.string :ricc_source

      t.timestamps
    end
  end
end
