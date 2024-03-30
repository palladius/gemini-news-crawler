json.extract! article, :id, :title, :summary, :content, :author, :link, :published_date, :image_url, :feed_url, :guid, :hidden_blurb, :language, :active, :ricc_internal_notes, :ricc_source, :created_at, :updated_at
json.url article_url(article, format: :json)
