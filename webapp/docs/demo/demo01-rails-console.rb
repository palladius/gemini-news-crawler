########################################################################
# Carlessian wisdom:
#
# This is saved as code and not markdown for two reasons:
# 1. Easier to check
# 2. Easy to integrate with rails console, for instance you can just type to test:
#
#   cat docs/demo/demo01-rails-console.rb | rails console
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
# # http://127.0.0.1:3000/
puts "1. See the result in localhost in http://127.0.0.1:3000/articles/#{a.id}"
puts "2. See the result in Cloud Run in https://gemini-news-crawler-dev-x42ijqglgq-ew.a.run.app/#{a.id}"


# visualize nicely
# Adds `neighbor_distance` from https://github.com/ankane/neighbor
# > nearest_item = item.nearest_neighbors(:embedding, distance: "euclidean").first
# > nearest_item.neighbor_distance

similaria.map{|a| [a.id, (a.neighbor_distance*100).round(2), a.title]}

# =>
# [[10446, 65.16, "Northern Lights Alert: Here’s Where Aurora Borealis Can Be Seen Tonight—As Forecasters Predict Strong Showing"],
#  [10442, 66.91, "Time to evacuate is running out as Hurricane Milton closes in on Florida - The Associated Press"],
#  [10448, 69.59, "Kyiv says Ukrainian reporter Victoria Roshchyna died in Russian detention"],
#  [10445, 70.57, "Wildlife Photographer of the Year: Tadpoles win top prize - BBC.com"],
#  [10444, 71.31, "Supreme Court’s conservatives wrestle with case of death row inmate Richard Glossip, who prosecutors want spared - CNN"]]

puts("We have a Bingo!")
