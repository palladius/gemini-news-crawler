
# This is sabved as code and not markdown for two reasons:
# 1. Easier to check
# 2. Easy to integrate with rails console, for instance you can just type to test:
#
#   cat docs/demo/demo01-rails-console.rb | rails console
#

a = Article.last
# make sure it has embeddings. :title_embedding is used for Article similarity here. A different one is used for semantic search
# Why? Came in 2 different times (March vs May) of the demo and it would take too long to re-calculate 10k embeddings.
 a.title_embedding
# IF it doesnt exist, calculate it
 a.compute_embeddings!

puts "1. See the result in localhost in https://localhost:3000/articles/#{Article.id}")
puts "2. See the result in Cloud Run in https://gemini-news-crawler-dev-x42ijqglgq-ew.a.run.app/#{Article.id}")
