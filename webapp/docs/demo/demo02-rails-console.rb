########################################################################
# Carlessian wisdom:
#
#   cat docs/demo/demo02-rails-console.rb | rails console
#
########################################################################

#@query = 'Ruby or Rails'
#@query = 'Donald Trump'
@query = 'Global warming'

# Uses latest Gemini to calculate embeddings.
@e = GeminiLLM.embed(text: @query).embedding
# @e is an embedding:
# => [0.032562922686338425,
#    -0.1233862042427063,
#    -0.021260954439640045,
#    -0.03331197798252106,
#    0.039575427770614624,
#    ...
#    ]

# Calculate closest articles based on:
# 1. ambedding model called: TODO
# 2. content: article (a smart union of title, body, ..)
@closest_articles = Article.select_sensible_columns.nearest_neighbors(:article_embedding, @e, distance: "euclidean").first(6)
#@closest_articles = Article.select_sensible_columns.nearest_neighbors(:article_embedding, @e, distance: "euclidean").first(6) # .order(:published_date)


# Visualizing for the crowd:
@closest_articles.map{|a| [a.id, a.fancy_neighbor_distance, a.title, a.tag_names.map{|x| x.to_sym} ] }
# =>
# [[5842, 77.74, "Live reload a Rails 7 application, an unsatisfaying attempt", []],
#  [215, 78.49, "Ruby on Rails-like ORM and scaffolding in Golang anyone?", []],
#  [5266, 80.2, "Outgrowing Heroku: An AWS Migration Story", []],
#  [4270, 82.87, "Rails guides facelift, two new official gems and more!", [:news]],
#  [6615, 83.05, "Daily Reading List – April 5, 2024 (#292)", [:"Daily Reading List"]],
#  [4269, 83.12, "Rails Guides get a facelift", [:news]]]

# TODO DRY this into some Demo helper/concern. Probably a concern sounds good.
# @short_prompt = "You are a prompt summarizer. You need to answer this quesiton: '''#{@query}''' after reading the following articles which seem the most pertinent.
# Pay attention to the recency of the articles, since the date of articles is provided and today's date is #{Date.today}. More recent is better.

# Date of today: #{Date.today}
# Query: '#{@query}'

# Using Helpers methods to guaranmtee DRY ness between this demo and the UI demo :)
# Devil of a DRY Riccardo or... #DRYCCARDO!
# Here are the #{@closest_articles.count} Articles:
# "
helpz = ApplicationController.helpers
#@short_prompt = ApplicationController.helpers.PromptHelper::rag_short_prompt(date: Date.today , query: 'ORM in PHP' , article_count: 42)
@short_prompt = helpz.rag_short_prompt(query: @query , article_count: @closest_articles.count)
puts(@short_prompt.colorize :yellow)

########################################################
# 1. If you want use SHORT
@articles_excerpts = @closest_articles.map{|a| helpz.sanitize_news a.excerpt_for_llm}.join("\n") # .to_s
puts(@articles_excerpts.colorize :cyan)
@long_prompt = helpz.rag_long_prompt(query: @query, article_count: @closest_articles.count, articles: @articles_excerpts )
@rag_excerpt = PalmLLM.complete(prompt: @long_prompt).output
puts(@rag_excerpt.colorize :green)
# =>
# There are 42 articles in total. The most recent one is published on 2024-04-06.

# The articles are about Ruby on Rails, including:
# - Live reload a Rails 7 application, an unsatisfaying attempt
# - Ruby on Rails-like ORM and scaffolding in Golang anyone?
# - Outgrowing Heroku: An AWS Migration Story
# - Rails guides facelift, two new official gems and more!
# - Daily Reading List – April 5, 2024 (#292)
# - Rails Guides get a facelift
########################################################

########################################################
# 2. If you want use LONG and read the whole article:
@articles_verbose = @closest_articles.map{|a| helpz.sanitize_news(a.article)}.join("\n") # .to_s
puts(@articles_verbose.colorize :cyan)
@long_prompt = helpz.rag_long_prompt(query: @query, article_count: @closest_articles.count, articles: @articles_verbose )
@rag_excerpt = PalmLLM.complete(prompt: @long_prompt).output
puts(@rag_excerpt.colorize :green)
# Output when RAG knows the content of article, not just the title.
# => """
# - Riccardo Carlesso: "Ruby on Rails-like ORM and scaffolding in Go". Riccardo Carlesso compares Ruby on Rails with Go and concludes that Golang has still a long way to go to get to Ruby feasts when it comes to ORM and Rails rapid-prototyping.
# - Outgrowing Heroku: An AWS Migration Story. This story details TeePublic's migration of their Rails monolith to Amazon ECS.
# - Rails guides facelift, two new official gems and more!. This article summarizes the latest updates for Rails, including a new design for the guides, two new official gems, and a number of bug fixes.
# - Daily Reading List – April 5, 2024 (#292). This reading list includes articles on queuing up your app deployments, how enterprises are spending their budgets on AI, and why Ruby on Rails isn't dead.
# - Rails Guides get a facelift. This article announces a new design for the Rails guides, which is cleaner, less busy, and more consistent with the Rails homepage.
# """

# If you change the search for 'Donald Trump' you get this nice excerpt:
# => """
# Donald Trump won the Republican presidential primary in Wisconsin.
# Trump's new attempt to stop justice is jaw-dropping.
# Putin and Netanyahu are waiting for Trump.
# Trumpers hope to rebound as state legislators.
# Is it finally Donald Trump's time to pay up?
# Scotland 'hoodwinked' by Trump, says former aide.
# """
