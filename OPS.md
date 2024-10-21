# Geminews Ops

What's new with operations on code and DB?

## 2024-10-21 Refresh evbeddings

Creating:

```
Article.all.first(50).each {|a| a.compute_embeddings! }
```

* now executed on top 1000
* amnd now on top 10k. tomorrow morning we see if search got better with `embeddings-004` :)
