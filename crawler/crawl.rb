require 'feedjira'
require 'httparty'
require 'colorize'
require_relative '../_env_gaic.rb'
require_relative './constants.rb'

MaxArticleSize = 3 # todo 100

def crawl_rss_feed(feed_url)
  feed = Feedjira::Feed.fetch(feed_url)

  feed.entries.each do |entry|
    title = entry.title
    summary = entry.summary
    link = entry.url  # Optional, if you want the full article link
    published_date = entry.published

    # Extract image URL if available (check for specific tag/attribute)
    image_url = entry.content&.css("img")&.first&.attributes["src"]&.value

    # Store data (replace with your preferred method)
    data = { title: title, summary: summary, link: link, published_date: published_date, image_url: image_url }
    store_data(data)
  end
end

def store_data(data)
  # Implement your data storage logic here (similar to previous example)
  # ...
end

# Example usage with RSS feed URLs
#crawl_rss_feed("https://www.repubblica.it/rss/homepage/rss2.xml")
#crawl_rss_feed("https://www.fattoquotidiano.it/feed/")
# ... add URLs for other news website RSS feeds

# def cache_filename(feed_url, article_data)
#   # Option 1: Using guid (if available)
#   article_data[:guid] ? "cache/#{feed_url}-#{article_data[:guid]}.json" : "cache/#{feed_url}-#{Digest::MD5.hexdigest(article_data.to_json)}.json"
# end


def main
  puts("🖖🏻 Welcome to Gemini News Parser v#{ProgVersion}")
  #print NEWS[:italy]
  url = NEWS[:italy].first
  NEWS[:italy].each do |newspaper_feed|
    url = newspaper_feed
    puts("🕷️  Crawling RSS Feed from: #{url.colorize :yellow}")
    xml = HTTParty.get(url).body
    feed = Feedjira.parse(xml) rescue nil
    if feed.nil?
      puts "❌ Some issues with parsing #{url}: #{$!}"
      next
    end
    puts("🕷️  #{feed.entries.count} news found.")
    #puts "This is blue".colorize(:blue)
    feed.entries.each_with_index do |rss_article, ix|
      break if ix == MaxArticleSize
      puts("📰 #{ix+1} Title: #{rss_article.title.colorize(:cyan)}")
#      puts("📰 categories:  #{rss_article.categories}")
    end
  end
end


main
