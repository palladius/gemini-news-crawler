#!/usr/bin/env ruby

########################################################
# This started as a crawler but became more as a
#
# Cool features:
# 1. Find fields from N different RSS feeds and print stats over them
# 1. Cache News into file so we dont hit too many things.
#
# Here's a stat for 300 websites with 10 articles:
# 📚 categories:  371
# 📚 entry_id:    371
# 📚 id:          371
# 📚 title:       371
# 📚 published:   370
# 📚 summary:     345
# 📚 image:       227
# 📚 author:      197
# 📚 comments:    40
# 📚 enclosure_url: 20
#
# This means I can count on these fields:
# id, title, entry_id, categories, published
########################################################


require 'feedjira'
require 'httparty'
require 'colorize'
require_relative '../_env_gaic.rb'
require_relative './constants.rb'
require_relative 'lib/news_cacher.rb'
require_relative 'lib/news_filer.rb'
require_relative 'lib/gcp.rb'
require 'tempfile'

MaxArticleSize = ENV.fetch('MAX_ARTICLE_SIZE', '2').to_i  # 10 # todo 100
MaxNewsWebsites = ENV.fetch('MAX_WEBSITES', '3').to_i  # 50 # todo 100
RssCacheInvalidationMinutes = ENV.fetch('RSS_CACHE_INVALIDATION_MINUTES', '15').to_i  # 15 # 15 minutes
SkipCrawling = ENV.fetch('SKIP_CRAWLING', 'false').downcase.to_s == 'true'


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
#crawl_rss_feed("https://www.repubblica.it/rss/homepage/rss2.xml")require 'google/cloud/storage'

#crawl_rss_feed("https://www.fattoquotidiano.it/feed/")
# ... add URLs for other news website RSS feeds

# def cache_filename(feed_url, article_data)
#   # Option 1: Using guid (if available)
#   article_data[:guid] ? "cache/#{feed_url}-#{article_data[:guid]}.json" : "cache/#{feed_url}-#{Digest::MD5.hexdigest(article_data.to_json)}.json"
# end

# https://stackoverflow.com/questions/60391815/how-to-create-file-with-google-cloud-storage
# def create_file(file, path = nil, acl: nil, cache_control: nil,
#   content_disposition: nil, content_encoding: nil,
#   content_language: nil, content_type: nil,
#   crc32c: nil, md5: nil, metadata: nil,
#   encryption_key: nil, encryption_key_sha256: nil)

#   #ensure_service!
#   options = { acl: File::Acl.predefined_rule_for(acl), md5: md5,
#   cache_control: cache_control, content_type: content_type,
#   content_disposition: content_disposition, crc32c: crc32c,
#   content_encoding: content_encoding,
#   content_language: content_language, metadata: metadata,
#   key: encryption_key, key_sha256: encryption_key_sha256 }
#   ensure_file_exists! file

#   path ||= Pathname(file).to_path
#   gapi = service.insert_file name, file, path, options
#   File.from_gapi gapi, service
# end

def copy_stuff_to_gcs(gcs_environment: , bucket_name:)
  require 'google/cloud/storage'

  relative_path_to_key = ENV['GCP_KEY_PATH'] # but need to add ../
  raise "ENV[GCP_KEY_PATH] is not set! " if relative_path_to_key.nil?
  project_id = ENV['PROJECT_ID']
  raise "ENV[PROJECT_ID] is not set! " if project_id.nil?

  path_to_key = "../#{relative_path_to_key}"

  puts("path_to_key: #{path_to_key}")
  raise "File not found: #{path_to_key}" unless File.exist?(path_to_key)

  export_version = "1.0"
  storage = Google::Cloud::Storage.new(
    project_id: project_id,
    credentials: path_to_key, # 'path/to/your/credentials.json'
    # retry https://cloud.google.com/storage/docs/retry-strategy?utm_source=devrel&utm_medium=api_error&utm_campaign=gcs429#ruby_1
    retries: 5,
    max_elapsed_time: 500,
    base_interval: 1,
    max_interval: 45,
    multiplier: 1.2,
  )

  bucket = storage.bucket(bucket_name)
  puts(" 🪣 Listing bucket content: #{bucket_name}")
  files = bucket.files
  # separating as in this doc: https://github.com/googleapis/google-cloud-ruby/blob/main/google-cloud-storage/lib/google/cloud/storage/file/list.rb
  files.all(request_limit: 5).each do |file|
    puts "🗄️  #{file.name}"
  end

  # GCS variables
  manifest_local_file = Tempfile.new('local_manifest')
  folder = "geminews-v#{export_version}/#{gcs_environment}" # relative
  full_folder = "gs://#{bucket_name}/#{folder}"
  manifest_path = "#{folder}/manifest.yaml"

  n_files_in_cache = Dir.glob('cache/**').count
  n_files_in_output = Dir.glob('out/feedjira/**/*').count
  # https://stackoverflow.com/questions/4823507/ruby-finding-most-recently-modified-file
  freshest_file_in_output = Dir.glob('out/feedjira/**/*').max_by {|f| File.mtime(f)}
  stalest_file_in_output = Dir.glob('out/feedjira/**/*').min_by {|f| File.mtime(f)}


  freshest_file_in_cache = Dir.glob('cache/**').max_by {|f| File.mtime(f)}

  puts("🟡 Pulling Manifest file: #{manifest_path}")
  puts('todo')

  manifest = {
    "hostname" => Socket.gethostname,
    "now" => Time.now,
    "manifest_version" => export_version,
    "folders" => {
      "output" => {
        'freshest_file' => freshest_file_in_output,
        'freshest_mtime' => File.mtime(freshest_file_in_output),
        'newest_file_freshness' => (Time.now - File.mtime(freshest_file_in_output)).to_i, # seconds
        'newest_file_freshness_hours' => ((Time.now - File.mtime(freshest_file_in_output))/3600), # seconds
        'stalest_file_freshness' => (Time.now - File.mtime(stalest_file_in_output)).to_i, # seconds
        "n_files" => n_files_in_output,
      },
      "cache" => {
        'freshest_file' => freshest_file_in_cache,
        'freshest_mtime' => File.mtime(freshest_file_in_cache),
        'freshest_deltatime' => Time.now - File.mtime(freshest_file_in_cache), # seconds
        "n_files" => n_files_in_cache,
      },
    },
  } # convert kets from sym to string or yaml is ugly! ;)
  manifest_local_file.write(manifest.to_yaml())
  # => yaml

  ########################################
  puts("🟡 Uploading manifest: #{manifest}")
  puts("  - manifest_path: #{manifest_path}")
  puts("Writing file '#{manifest_local_file.path}' to #{manifest_path}")
  #bucket.create_file(manifest_local_file.path, manifest_path) # local, remote
  gcs_upload_file_from_memory \
    storage: storage,
    bucket_name: bucket_name,
    file_name: manifest_path,
    file_content: manifest.to_yaml()
  # file = bucket.create_file StringIO.new(file_content), file_name

  puts("🟡 Checking content folder: #{folder}")
  # https://cloud.google.com/storage/docs/listing-objects#storage-list-objects-ruby
  bucket.files(prefix: folder).each do |file| #  bucket.files prefix: prefix, delimiter: delimiter
    puts "[F] - #{file.name}"
  end
  puts("🟡 Copy cache/ to folder: #{manifest_path}")
  #bucket_name = 'bucket'
  remote_folder_path = full_folder + '/cache'
  local_dir = 'cache/'

  ####################################################################################
  # Copy all files from local `cache/...` to gs://BUCKET_NAME/gemoinews-v1.0/development/cache/...
  ####################################################################################

  file_counter = 1
  Dir.glob(File.join(local_dir, '**/*')) do |local_file|
    next if File.directory?(local_file) # Skip directories
    #break if file_counter == 5
    # if file_counter % 9 == 0
    #   puts("💤 skeeping 1 sec")
    #   sleep(1)
    # end
    remote_file_path = File.join(remote_folder_path, local_file.sub(local_dir, ''))
    puts " ⬆️ #{file_counter} Uploading local '#{local_file}' -> remote '#{remote_file_path}'" # 🛗
    #puts(`ls -al '#{local_file}'`)
    if File.size?(local_file) == 0
      puts("0️⃣ Skipping '#{local_file}' as zero size..")
    else
        bucket.create_file(
        local_file,
        folder + '/' + local_file,
        #folder
        ) # local, remote
    end
    file_counter += 1
  end
  puts('Done!')

end


def main
  field_counters = {}
  entries4all= {}
  puts "=============================="
  puts("🖖🏻 Welcome to Gemini News Parser v#{ProgVersion}")
  puts "🌱 MaxArticleSize:       #{MaxArticleSize}"
  puts "🌱 MaxNewsWebsites:      #{MaxNewsWebsites}"
  puts "🌱 RssCacheInvalidation: #{RssCacheInvalidationMinutes}m"
  puts "=============================="

  #print NEWS[:italy]
  #url = NEWS[:italy].first

  if SkipCrawling
    puts("Bummer: I wont crawl as SkipCrawling has been set to true")
  else
  NEWS_BY_REGION.each do |macro_region, blurb|
    puts("🌎🌎🌎 MACRO REGION: #{macro_region} 🌎🌎🌎")
    #NEWS[:italy].each do |newspaper_friendly_name, newspaper_feed|
    ix=0
    blurb.each do |newspaper_friendly_name, newspaper_feed|
      ix += 1
      break if ix > MaxNewsWebsites
      file_dumper = NewsFiler.new("out/feedjira/#{macro_region}/#{newspaper_friendly_name}/")
      url = newspaper_feed
      print("🕷️ #{ix}  Crawling RSS Feed from: #{newspaper_friendly_name.to_s.colorize :yellow} # #{url}")
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
        break if ix == MaxArticleSize

        # In case Title is not defined or its VERY short - lets pass to the next news
        next if rss_article.title.to_s.length < 4

        puts("📰 [#{ix+1}] Title: #{rss_article.title.colorize(:cyan)}")
        file_dumper.write_article(newspaper_friendly_name, rss_article, macro_region)
        # All verbs but ENTRIES
        RSSVerbs.each do |verb|
          field_counters[verb] ||= 0
          if (rss_article.send verb rescue nil).to_s.length > 0
            field_counters[verb] += 1
            # puts("📚 #{verb}:  #{rss_article.send verb}") rescue nil
          end
        end
        # Entries verb has many things
        if (rss_article.send 'entries' rescue nil).to_s.length > 0
          rss_entries_keys = rss_article.entries.map{|x| x[0]}
          #puts("🧑🏻‍💻 ENTRIES:  #{}")
          # Setting this for statistics
          entries4all[newspaper_friendly_name] = rss_entries_keys.join(',') if rss_entries_keys.is_a? Array
        end
      end
    end #/Newspaper within macro region
  end # Macro Region


  puts 'Done with the super duper hyper-loop.'

  print("field_counters: ", field_counters)
  field_counters.map{|x,y| [x,y]}.sort_by{|x,y|-y}.each do |article_field, cardinality|
    puts("📚 #{article_field}:\t#{cardinality}")
  end
  #print("entries4all: ", entries4all)
  entries4all.sort.each do |k, entries|
    puts("📚 #{k}:\t#{entries}")
  end

end # SkipCrawling


###################
# do the GCP stuff
###################

  if ENV['ENABLE_GCP'].to_s == 'true'
    gcs_environment = ENV.fetch 'GCS_ENV', 'development'
    bucket_name = ENV.fetch 'BUCKET_NAME'
    raise "BUCKET_NAME not given! " if bucket_name.nil?
    puts("☁️ Nuclear GCP launch detected! (ENABLE_GCP=true)")
    copy_stuff_to_gcs(gcs_environment: gcs_environment, bucket_name: bucket_name ) # puts("☁️ Nuclear GCP launch detected! (ENABLE_GCP=true)")
  end
end


main
