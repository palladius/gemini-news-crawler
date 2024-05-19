########################################################################
# Carlessian wisdom:
#
#   cat docs/demo/demo02-rails-console.rb | rails console
#
########################################################################

a = Article.last
# make sure it has embeddings. :title_embedding is used for Article similarity here. A different one is used for semantic search
# Why? Came in 2 different times (March vs May) of the demo and it would take too long to re-calculate 10k embeddings.
 a.title_embedding
# IF it doesnt exist, calculate it
 a.compute_embeddings! unless a.title_embedding?
 # compute 5 `similarest` articles
similaria = a.similar_articles(max_size: 5)

# looks better on UI
puts "1. See the result in localhost in https://localhost:3000/articles/#{Article.id}")
puts "2. See the result in Cloud Run in https://gemini-news-crawler-dev-x42ijqglgq-ew.a.run.app/#{Article.id}")


# visualize nicely
# Adds `neighbor_distance` from https://github.com/ankane/neighbor
# > nearest_item = item.nearest_neighbors(:embedding, distance: "euclidean").first
# > nearest_item.neighbor_distance

similaria.map{|a| [a.id, (a.neighbor_distance*100).round(2), a.title]}

puts("We have a Bingo!")
