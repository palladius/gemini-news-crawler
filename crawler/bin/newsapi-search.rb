#!/usr/bin/env ruby
=begin


# # /v2/top-headlines
# top_headlines = newsapi.get_top_headlines(q: 'bitcoin',
#                                           sources: 'bbc-news,the-verge',
#                                           category: 'business',
#                                           language: 'en',
#                                           country: 'us')

# # /v2/everything
# all_articles = newsapi.get_everything(q: 'bitcoin',
#                                       sources: 'bbc-news,the-verge',
#                                       domains: 'bbc.co.uk,techcrunch.com',
#                                       from: '2017-12-01',
#                                       to: '2017-12-12',
#                                       language: 'en',
#                                       sortBy: 'relevancy',
#                                       page: 2))


=end
require 'json'
require "uri"
require "net/http"
# gem install news-api
require 'news-api'


KEY =  ENV['NEWSAPI_COM_KEY'] # NEWSAPI_COM_KEY_RICC for another key
SearchString = ARGV.join(' ')
puts '♦️' * 70
puts("♦️ Riccardo, they key is: #{KEY}")
puts("♦️ Riccardo, they search string is: '#{SearchString}'")
puts '♦️' * 70
puts ''

raise "KEY non datur: mihi date clavem!" if KEY.to_s.empty?
raise "SearchString non datur: mihi date quidam ARGVem!" if SearchString.to_s.empty?


def print_nicely_formatted_results(description: , headlines:, max: 5)
  puts("== #{description} ==")
  headlines.each_with_index do |a, ix|
    return if ix >= max
    # if ix==0
    #   puts '----'
    #   #puts a.class
    #   puts a.inspect
    #   #<Everything:0x000000010f847938 @id="bbc-news", @name="BBC News", @author="BBC News", @title="Samsung: Tech giant sees profits jump by more than 900%", @description="Chip prices recover from a post-pandemic slump while demand for AI-related products booms.", @content="Samsung Electronics says it expects its profits for the first three months of 2024 to jump by more than 10-fold compared to a year earlier.\r\nIt comes as prices of chips have recovered from a post-pan… [+1412 chars]", @url="https://www.bbc.co.uk/news/business-68738046", @urlToImage="https://ichef.bbci.co.uk/news/1024/branded_news/1B74/production/_133082070_gettyimages-2035078774.jpg", @publishedAt="2024-04-05T07:37:21.2983005Z">url=, url, author=, id=, urlToImage=, publishedA
    #   #puts a.methods.join(', ')
    #   puts '----'
    # end
    puts("📰 [#{a.author}] #{a.publishedAt} '[#{a.language rescue :en}] #{a.title}' 🌏 #{a.url}" )
  end


end
n = News.new(KEY)

n.get_sources(country: 'us', language: 'en')

# You are trying to request results too far in the past. Your plan permits you to request articles as far back as 2024-03-05, but you have requested 2018-01-05. You may need to upgrade to a paid plan.
ret1 = n.get_everything(
  q: SearchString,
  from: "2024-03-15&to=2024-04-06",
  sortBy: "popularity")


headlines = n.get_top_headlines(sources: "bbc-news")

print_nicely_formatted_results(description: '🇬🇧 Top headlines from BBC', headlines: headlines)

print_nicely_formatted_results(description: "🕵️‍♂️ Search for '#{SearchString}'", headlines: ret1)
