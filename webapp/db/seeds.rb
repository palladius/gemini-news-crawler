# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

if ENV['DESTROY_ALL_BEFORE'] == 'YES_WHY_NOT'
  Article.delete_all
  Category.delete_all
end

Article.create(
  title: 'Another sport news about politics',
  categories: ['sport', 'politics', '2024-04-01'],
  summary: 'Lets see if I can make this into creating the categories automatically by patching the model',
  guid: 'rake-seed-01',
  published_date: Time.now,
  hidden_blurb: 'TODO the whole object I get from new API calls',
)
Article.create(
  title: 'Trump vs Berlusconi',
  categories: ['italy', 'politics', '2024-04-01'],
  summary: 'Lets see if I can make this into creating the categories automatically by patching the model',
  guid: 'rake-seed-02',
)
Category.create(name: 'manhouse')

puts "✅ Now we have #{Category.all.count} categories"
puts "❌ Now we have #{ArticleTag.all.count} ArticleTags (should be >0)"
