################################################
# This library gives you a NewsCacher.
#
# TODO(P1): refactor feed_url into initializer
################################################

#require 'feedjira'
require 'httparty'
require 'digest' # https://ruby-doc.org/stdlib-2.4.0/libdoc/digest/rdoc/Digest/MD5.html

# Caches a file for 30min..
class NewsCacher
  def initialize(cache_dir = "cache", cache_duration = 30)
    @cache_dir = cache_dir
    @cache_duration = cache_duration
  end

  def cache_filename(feed_url)
    "#{@cache_dir}/#{Digest::MD5.hexdigest(feed_url)}.xml"
  end

  def cache_valid?(feed_url)
    filename = cache_filename(feed_url)
    File.exist?(filename) && (Time.now - File.mtime(filename)) < @cache_duration * 60
  end

  def cache_freshness_minutes(feed_url)
    filename = cache_filename(feed_url)
    return -1 unless File.exist?(filename)
    ((Time.now - File.mtime(filename)) / 60).to_i
  end

  def fetch_and_cache_feed(feed_url)
    #begin
      xml = HTTParty.get(feed_url).body rescue nil # TODO catch error
    #rescue
    #  raise "Error fetching: #{feed_url}"
    #end
    filename = cache_filename(feed_url)
    File.open(filename, "w") do |f|
      # f.write("<!-- Written by NewsCacher-->\n")
      # f.write("<!-- feed_url: '#{feed_url}' -->\n")
      f.write(xml)
    end
  end

  def cached_feed(feed_url, verbose: false)
    if verbose
      puts("# #{feed_url} -> cache_valid? #{cache_valid?(feed_url) ? '✅' : '❌'}")
    end
    filename = cache_filename(feed_url)
    return nil unless cache_valid?(feed_url)
    File.read(filename)
  end

  def print_stats(feed_url)
    puts "[Autocache] feed_url           = #{feed_url}"
    puts "[Autocache] cache_valid?       = #{cache_valid? feed_url}"
    puts "[Autocache] cache_freshness    = #{cache_freshness_minutes(feed_url)}min"
    puts "[Autocache] cache_invalidation = #{@cache_duration}min"
  end

  def autocache(feed_url, verbose: true)
    if !self.cache_valid?(feed_url)
      self.fetch_and_cache_feed(feed_url)
    end
    print_stats(feed_url) if verbose
    self.cached_feed(feed_url)
  end
end

# # Example usage
# cacher = NewsCacher.new
# feed_url = 'https://www.repubblica.it/rss/esteri/rss2.0.xml'
# cached_data = cacher.autocache(feed_url)
