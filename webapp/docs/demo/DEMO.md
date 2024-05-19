
# Demo 1 - Article / Embeddings

## 🧠🧐 About

In this demo we want to demonstrate the ability for Ruby on Rails + PostgreS to easily host.

Lesson learnt: embeddings are BIG, and they slow significantly ActiveRecord retrievals.
Once you marry one embedding (I have 3 per article, 768 integers for each), you need to learn how to selectively `SELECT(:field1, :field2)` for the queries you do. For articles, that brought my time from 6 seconds to 50ms. 😱

## CLI + Rails Console

💻 Command line:

```
cd webapp/ # Go into rails folder
rails c  # opens console
```

Within 🚊💻 Rails Console:

```
a = Article.last
# make sure it has embeddings. :title_embedding is used for Article similarity here. A different one is used for semantic search
# Why? Came in 2 different times (March vs May) of the demo and it would take too long to re-calculate 10k embeddings.
 a.title_embedding
# IF it doesnt exist, calculate it
 a.compute_embeddings! unless a.title_embedding?
similaria = a.similar_articles(max_size: 5)

# visualize nicely
# Adds `neighbor_distance` from https://github.com/ankane/neighbor
# > nearest_item = item.nearest_neighbors(:embedding, distance: "euclidean").first
# > nearest_item.neighbor_distance

similaria.map{|a| [a.id, a.title, (a.neighbor_distance*100).round(2) ]}

puts("Bingo!")
```

# Demo 2



# Demo 3



# Demo 4

