# Geminews Ops

What's new with operations on code and DB?

## 2024-10-21 Refresh embeddings

Creating:

```
Article.all.first(50).each {|a| a.compute_embeddings! }
```

* now executed on top 1000
* and now on top 10k. tomorrow morning we see if search got better with `embeddings-004` :)

* as of 22oct24 - 10000 out of 10256 Articles are v3 now with new recalculated embeddings.
* How to find the 256 old ones?


First (new) vs last (old):

```ruby
> Article.first.embeddings_palooza
{:env=>"development",
 "title_embedding_class"=>Array,
 "title_embedding_meaning"=>
  "[768 array][OLD yet productive] This is the embedding used. Its computed with an old algorithm nd its only compatiblwe with THAT algorithm. This distance is used to calculate distance across articles in demo1 and in the article view. Im not 100% sure but I believe it uses Google multilang embedding model",
 "title_embedding_description"=>
  "{:ricc_notes=>\"[embed-v3] Fixed on 9oct24. Only seems incompatible at first glance with embed v1.\", :llm_project_id=>\"unavailable possibly not using Vertex\", :llm_dimensions=>nil, :article_size=>372, :poly_field=>\"title\", :llm_embeddings_model_name=>\"textembedding-gecko\"}",
 "title_embedding_array_len"=>768,
 "title_embedding_array_sample123"=>[-0.01720817, -0.038322747, -0.0041960096],
 "summary_embedding_class"=>Array,
 "summary_embedding_meaning"=>"[768 array] I believe this is NOT utilized 🏧",
 "summary_embedding_description"=>
  "{:ricc_notes=>\"[embed-v3] Fixed on 9oct24. Only seems incompatible at first glance with embed v1.\", :llm_project_id=>\"unavailable possibly not using Vertex\", :llm_dimensions=>nil, :article_size=>372, :poly_field=>\"summary\", :llm_embeddings_model_name=>\"textembedding-gecko\"}",
 "summary_embedding_array_len"=>768,
 "summary_embedding_array_sample123"=>[0.057199053, -0.03746515, 0.043959897],
 "article_embedding_class"=>Array,
 "article_embedding_meaning"=>"[768 array] I believe it uses Google single-lamnguage strongest newest model.",
 "article_embedding_description"=>"{:llm_project_id=>\"Unavailable\", :llm_dimensions=>nil, :article_size=>372, :llm_embeddings_model_name=>\"textembedding-gecko\"}",
 "article_embedding_array_len"=>768,
 "article_embedding_array_sample123"=>[0.020674584, -0.0051829284, 0.0032295026]}

[..]

> Article.last.embeddings_palooza
   Article Load (36.3ms)  SELECT "articles".* FROM "articles" ORDER BY "articles"."id" DESC LIMIT $1  [["LIMIT", 1]]
=>
{:env=>"development",
 "title_embedding_class"=>Array,
 "title_embedding_meaning"=>
  "[768 array][OLD yet productive] This is the embedding used. Its computed with an old algorithm nd its only compatiblwe with THAT algorithm. This distance is used to calculate distance across articles in demo1 and in the article view. Im not 100% sure but I believe it uses Google multilang embedding model",
 "title_embedding_description"=>
  "{:ricc_notes=>\"[embed-v3] Fixed on 9oct24. Only seems incompatible at first glance with embed v1.\", :llm_dimensions=>nil, :article_size=>617, :poly_field=>\"title\", :llm_embeddings_model_name=>\"textembedding-gecko\"}",
 "title_embedding_array_len"=>768,
 "title_embedding_array_sample123"=>[0.038985893, -0.019458583, -0.00915442],
 "summary_embedding_class"=>Array,
 "summary_embedding_meaning"=>"[768 array] I believe this is NOT utilized 🏧",
 "summary_embedding_description"=>
  "{:ricc_notes=>\"[embed-v3] Fixed on 9oct24. Only seems incompatible at first glance with embed v1.\", :llm_dimensions=>nil, :article_size=>617, :poly_field=>\"summary\", :llm_embeddings_model_name=>\"textembedding-gecko\"}",
 "summary_embedding_array_len"=>768,
 "summary_embedding_array_sample123"=>[0.038985893, -0.019458583, -0.00915442],
 "article_embedding_class"=>Array,
 "article_embedding_meaning"=>"[768 array] I believe it uses Google single-lamnguage strongest newest model.",
 "article_embedding_description"=>"{:llm_dimensions=>nil, :article_size=>617, :llm_embeddings_model_name=>\"textembedding-gecko\"}",
 "article_embedding_array_len"=>768,
 "article_embedding_array_sample123"=>[0.05530524, 0.03121252, 0.0065173884]}

Now added embeddings CORRECTLY and now recasting it

```ruby
irb(main):016> Article.last(30).each{|a| a.compute_embeddings! }
[..]
> Article.last.llm_info

 :llm_info=>
  ["[v2] article_embedding_description: {:llm_project_id=>\"Unavailable\", :llm_dimensions=>nil, :article_size=>617, :llm_embeddings_model_name=>\"text-embedding-004\"}",
   "[v1/3] title_embedding_description: {:ricc_notes=>\"[embed-v3] Fixed on 9oct24. Only seems incompatible at first glance with embed v1.\", :llm_project_id=>\"unavailable possibly not using Vertex\", :llm_dimensions=>nil, :article_siz
e=>617, :poly_field=>\"title\", :llm_embeddings_model_name=>\"text-embedding-004\"}",
   "[v1/3] summary_embedding_description: {:ricc_notes=>\"[embed-v3] Fixed on 9oct24. Only seems incompatible at first glance with embed v1.\", :llm_project_id=>\"unavailable possibly not using Vertex\", :llm_dimensions=>nil, :article_s
ize=>617, :poly_field=>\"summary\", :llm_embeddings_model_name=>\"text-embedding-004\"}",
   "As per bug https://github.com/palladius/gemini-news-crawler/issues/4 we can state this article belongs to titile/summary version: v3 (very few articles updated on 9oct24)"]}

```

Also `cleanup_ugly_backslashes` works REALLY well. We could actually pass through the same DB.
