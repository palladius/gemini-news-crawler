require 'feedjira'
require 'httparty'
require 'colorize'
require_relative '../_env_gaic.rb'
require_relative './constants.rb'
require_relative './news_cacher.rb'
#NewsCacher

MaxArticleSize = 1 # todo 100
RssCacheInvalidationMinutes = 15 # 15 minutes

Useless = %w{ enclosure category guid language lastmod loc pubDate description link publication_date pub_date elevation dcterms
  entries
} # need to remove ENTRIES or its a mess


# Added from https://github.com/feedjira/feedjira/blob/main/lib/feedjira/parser/rss.rb
# 📚 categories:  36
# 📚 title:       36
# 📚 entries:     36
# 📚 entry_id:    36
# 📚 image:       23
# 📚 author:      20
# 📚 comments:    4
# 📚 enclosure_url:       3
RSSVerbs = %w{
  author
  categories category
  comments
  guid link dcterms
  image entry_id description
  language
  pub_date publication_date
  enclosure enclosure_url
  link loc lastmod
  title
  id

  language image
   entries

   title url summary published entry_id
   title url summary author categories published entry_id image


  }.sort.uniq - Useless

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
  field_counters = {}
  entries4all= {}
  puts("🖖🏻 Welcome to Gemini News Parser v#{ProgVersion}")
  #print NEWS[:italy]
  url = NEWS[:italy].first
  NEWS[:italy].each do |newspaper_friendly_name, newspaper_feed|
    url = newspaper_feed
    print("🕷️  Crawling RSS Feed from: #{newspaper_friendly_name.to_s.colorize :yellow} # #{url}")
    #xml = HTTParty.get(url).body
    #cacher.autocache(feed_url)
    cacher = NewsCacher.new
    xml  = cacher.autocache(url, verbose: false)
    feed = Feedjira.parse(xml) rescue nil
    if feed.nil?
      puts "❌ Some issues with parsing #{url}: #{$!}".colorize(:red)
      next
    end
    puts(" -->  #{feed.entries.count.to_s.colorize(:blue)} news found.")
#    puts feed.entries.first.methods
    feed.entries.each_with_index do |rss_article, ix|
      #puts rss_article.to_s
      break if ix == MaxArticleSize
      puts("📰 [#{ix+1}] Title: #{rss_article.title.colorize(:cyan)}")
      # All verbs but ENTRIES
      RSSVerbs.each do |verb|
        field_counters[verb] ||= 0
        if (rss_article.send verb rescue nil).to_s.length > 0
          field_counters[verb] += 1
          puts("📚 #{verb}:  #{rss_article.send verb}") rescue nil
        end
      end
      # Entries verb has many things
      if (rss_article.send 'entries' rescue nil).to_s.length > 0
        rss_entries_keys = rss_article.entries.map{|x| x[0]}
        #puts("🧑🏻‍💻 ENTRIES:  #{}")
        entries4all[newspaper_friendly_name] = rss_entries_keys.join(',') if rss_entries_keys.is_a? Array
      end
    end
    #cacher.print_stats(url) if verbose
  end
  #
  print("field_counters: ", field_counters)
  field_counters.map{|x,y| [x,y]}.sort_by{|x,y|-y}.each do |article_field, cardinality|
    puts("📚 #{article_field}:\t#{cardinality}")
  end
  #print("entries4all: ", entries4all)
  entries4all.sort.each do |k, entries|
    puts("📚 #{k}:\t#{entries}")
  end
end


main
