require 'news-api'

require_relative './constants.rb'
require_relative '../_env_gaic.rb'

# Init
# puts('NEWSAPI_COM_KEY: ', ENV['NEWSAPI_COM_KEY'])
# exit( 42)

newsapi = News.new(ENV['NEWSAPI_COM_KEY'])

# # /v2/top-headlines
top_headlines = newsapi.get_top_headlines(q: 'bitcoin',
                                          sources: 'bbc-news,the-verge',
                                          category: 'business',
                                          #language: 'en',
                                          #country: 'us'
                                          )

# newsapi.get_everything(q: 'bitcoin',
#                                       sources: 'bbc-news,the-verge',
#                                       domains: 'bbc.co.uk,techcrunch.com',
#                                       from: '2017-12-01',
#                                       to: '2017-12-12',
#                                       language: 'en',
#                                       sortBy: 'relevancy',
#                                       page: 2))
