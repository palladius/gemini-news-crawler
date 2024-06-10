# frozen_string_literal: true

puts 'Skipping this for now.. until the other import script works'
if false
  Article.create(
    title: 'Another sport news about politics 3',
    categories: %w[sport politics 2024-04-01],
    summary: 'Lets see if I can make this into creating the categories automatically by patching the model',
    guid: 'rake-seed-01',
    published_date: Time.now,
    hidden_blurb: 'TODO the whole object I get from new API calls'
  )
  Article.create(
    title: 'Trump vs Berlusconi',
    categories: %w[italy politics 2024-04-01],
    summary: 'Lets see if I can make this into creating the categories automatically by patching the model',
    guid: 'rake-seed-02'
  )
  Category.create(name: 'manhouse')

  puts "✅ Now we have #{Category.all.count} categories"
  puts "❌ Now we have #{ArticleTag.all.count} ArticleTags (should be >0)"
end
