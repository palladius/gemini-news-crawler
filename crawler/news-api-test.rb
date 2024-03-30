#!/usr/bin/env ruby

require 'news-api'

require_relative './constants.rb'
require_relative '../_env_gaic.rb'

# Init
# puts('NEWSAPI_COM_KEY: ', ENV['NEWSAPI_COM_KEY'])
# exit( 42)

newsapi = News.new(ENV['NEWSAPI_COM_KEY'])

# possible_newspapers.first
#<Source:0x000000012ebdc408
# @category="general",
# @country="us",
# @description="Your trusted source for breaking news, analysis, exclusive interviews, headlines, and videos at ABCNews.com.",
# @id="abc-news",
# @language="en",
# @name="ABC News",
# @url="https://abcnews.go.com">
possible_newspapers =  newsapi.get_sources(
  #country: 'us',
  language: 'it')
possible_newspapers.each do |np|
  puts("🗞️ [#{np.country}][#{np.language}] #{np.url}")
end
# puts newsapi.get_everything(q: "apple", from: "2024-01-05&to=2018-01-05", sortBy: "popularity")

top_news =  newsapi.get_top_headlines(sources: "bbc-news")

# @author="BBC News",
# @content=
#  "Sir Jeffrey Donaldson has been charged with historical sexual offences and has quit as Democratic Unionist Party (DUP) leader.\r\nA 57-year-old woman has also been charged with aiding and abetting in c… [+2135 chars]",
# @description="Sir Jeffrey Donaldson is charged with historical sexual offences and has been suspended from the DUP.",
# @id="bbc-news",
# @name="BBC News",
# @publishedAt="2024-03-29T13:22:18.2737511Z",
# @title="DUP leader Sir Jeffrey Donaldson quits after sex offence charges",
# @url="https://www.bbc.co.uk/news/uk-northern-ireland-68686691",
# @urlToImage="https://ichef.bbci.co.uk/news/1024/branded_news/6684/production/_133044262_sirjeffreycapture.png">
puts("🇬🇧 Latest from BBC:")
top_news.each do |x|
  puts "[#{x.publishedAt[0,10]}] #{x.title}"
end

# # /v2/top-headlines
# top_headlines = newsapi.get_top_headlines(q: 'bitcoin',
#                                           sources: 'bbc-news,the-verge',
#                                           category: 'business',
#                                           #language: 'en',
#                                           #country: 'us'
#                                           )
#puts(top_headlines)
# newsapi.get_everything(q: 'bitcoin',
#                                       sources: 'bbc-news,the-verge',
#                                       domains: 'bbc.co.uk,techcrunch.com',
#                                       from: '2017-12-01',
#                                       to: '2017-12-12',
#                                       language: 'en',
#                                       sortBy: 'relevancy',
#                                       page: 2))

# Can also do this:
# GET https://newsapi.org/v2/everything?domains=techcrunch.com,thenextweb.com&apiKey=ee7986b14e2149a8ba3ba833871f6580
