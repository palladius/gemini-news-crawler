# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_03_30_204153) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "article_tags", force: :cascade do |t|
    t.bigint "article_id", null: false
    t.bigint "category_id", null: false
    t.text "ricc_internal_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_article_tags_on_article_id"
    t.index ["category_id"], name: "index_article_tags_on_category_id"
  end

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.text "summary"
    t.text "content"
    t.string "author"
    t.string "link"
    t.datetime "published_date"
    t.string "image_url"
    t.string "feed_url"
    t.string "guid"
    t.text "hidden_blurb"
    t.string "language"
    t.boolean "active"
    t.text "ricc_internal_notes"
    t.string "ricc_source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "ricc_internal_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "article_tags", "articles"
  add_foreign_key "article_tags", "categories"
end
