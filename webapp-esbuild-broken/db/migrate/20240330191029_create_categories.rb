class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :ricc_internal_notes

      t.timestamps
    end
  end
end
