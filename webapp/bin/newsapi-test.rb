#!/usr/bin/env ruby

# gem install news-api

require 'news-api'

# copied from https://newsapi.org/docs/client-libraries/ruby

NEWSAPI_KEY = ENV.fetch('NEWS_API_KEY')
puts("🔑 NEWSAPI_KEY (private!! Do not paste it!!): #{NEWSAPI_KEY}")

# Init
newsapi = News.new(NEWSAPI_KEY)

# /v2/top-headlines
# top_headlines = newsapi.get_top_headlines(q: 'bitcoin',
#                                           sources: 'bbc-news,the-verge',
#                                           category: 'business',
#                                           language: 'en',
#                                           country: 'us')
# puts(top_headlines)
# /v2/everything
all_articles = newsapi.get_everything(q: 'Google',
                                      sources: 'bbc-news,the-verge',
                                      domains: 'bbc.co.uk,techcrunch.com',
                                      #from: '2024-08-04',
                                      #to: '2024-08-05',
                                      language: 'en',
                                      sortBy: 'relevancy',
                                      page: 2)
###

puts("🗞️ #{all_articles.count} articles found")
puts("🗞️ First article: #{all_articles.first.inspect}")

# /v2/top-headlines/sources
#sources = newsapi.get_sources(country: 'us', language: 'en')
sources = newsapi.get_sources(country: 'it', language: 'it')
puts("📰 #{sources.count} Italian sources found. First source:")
puts(sources.first.inspect)
sources.each do |src|
    puts("📰 #{src.name} \t#{src.url}")
end
