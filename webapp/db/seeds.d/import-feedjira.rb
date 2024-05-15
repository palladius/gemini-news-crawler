require 'feedjira'

MaxArticlesToParse = 1000 # 2000
FeedJiraSubdir =  '/../../../crawler/out/feedjira/' # relative to here: db/seeds.d/HERE
Verbose = false

# skipping articles older than N days
def article_older_than_one_week?(file_path, n_days: 2)
  one_week_ago = Time.now - n_days * 24 * 60 * 60  # Calculate time one week ago
  File.mtime(file_path) < one_week_ago        # Compare file modification time
end

def published_date_too_old(x)
  unless x.is_a?(Time)
    puts "'#{x}' is Not a time! "
    return true # not correct but... whatevs i dont want articles with no date!
  end
  max_delta = 24 * 60 * 60 # 1 day
  delta_t = Time.now - x

  delta_t > max_delta
end


dir = File.dirname(__FILE__) + FeedJiraSubdir
unless Dir.exist?(dir)
  puts "🎯  ERROR - doesnt seem a dir: #{dir}. Since this could be running in docker - Im gonna scoop NICELY the CGB way"
  return
end

def parse_feedjira_from_yaml(jira_feed, file)
  o = jira_feed # less characters :)
  puts("+ parse_feedjira_from_yaml(jira_feed=#{o}, file=#{file})")
  puts("+ parse_feedjira_from_yaml(title='#{o.title}')")

  already_exists =  Article.find_by_title(o.title)
  puts("+ parse_feedjira_from_yaml(already_exists='#{already_exists}')")

  if already_exists
    Verbose ?
      puts("🎯 [CACHE HIT] Skipping: '#{o.title}'") :
      print('🎯')
    return
  else
  #  puts("🍅 [FRESH NEWS] #{o.published_date.to_date} '#{o.title}'")
    puts("🍅 [FRESH NEWS] #{o.published.to_date} '#{o.title}'")
  end

  unsafe_feed = YAML.unsafe_load(o.to_yaml) # ["carlessian_info"]
  if unsafe_feed['carlessian_info']
    #puts("🧡 Carlessian info unmarhsalled! WoOOT! #{  unsafe_feed['carlessian_info'] }")
    newspaper = unsafe_feed['carlessian_info']['newspaper']
    macro_region = unsafe_feed['carlessian_info']['macro_region']
  end

  #puts("o.published=#{o.published}")

  ret = Article.create(
    title: o.title,
    categories: o.categories, #   + ['2024-03-31', 'feedjira'],
    summary: o.summary,
    content: (o.content rescue '_NoContent_'),
    guid: o.entry_id, # = guid
    author: o.author,
    link: o.url,
    feed_url: o.url,
    published_date: o.published, # time into date
    active: true,
    ricc_internal_notes: "Imported via #{__FILE__} on #{Time.now}. Content is EMPTY here. Entried: #{o.entries.map{|x| x[0] }.join(',')}. TODO add Newspaper: filename = #{file}",
    #language: 'boh credo inglese', # Gemini can infer this
    image_url: o.image,
    ricc_source: 'feedjira::v1',
    hidden_blurb: o.to_yaml,
    newspaper: newspaper,
    macro_region: macro_region,
  )
  puts("article created? #{ret}")
  ret
end


Dir[File.join(File.dirname(__FILE__), FeedJiraSubdir, '**', '*.yaml')].each_with_index do |file, ix|
  next if ix  >= MaxArticlesToParse
  old_file = article_older_than_one_week?(file)
  # 👴 if old
  if old_file
    Verbose ?
      puts("[👴] File ##{ix}: #{ file} - OLD? #{old_file}") :
      print('👴')
    next
  end

  Verbose ?
    puts("💾 File ##{ix}: #{ file}") :
    print('💾')

  obj = YAML.load(
    File.read(file),
    aliases: true,
    permitted_classes: [
        Time,
        Feedjira::Parser,
        Feedjira::Parser::RSSEntry,
        Feedjira::Parser::GloballyUniqueIdentifier,
        Feedjira::Parser::ITunesRSSItem,
        Feedjira::Parser::AtomEntry,
    ]
  ) rescue nil

  if obj.nil?
    print('🧘')
    next
  end

  #puts(obj.published.class)
  if published_date_too_old(obj.published)
    # published: 2024-05-13 16:36:15.000000000 Z
    # updated: 2024-05-13 16:36:15.000000000 Z
    Verbose ? # old woman
      puts("[👵] #{obj.published} #{file} -> #{((Time.now - obj.published)/60/60/24).to_i}-days old") :
      print("👵")
    next
  end

  if obj.is_a?(Feedjira::Parser::RSSEntry) or obj.is_a?(Feedjira::Parser::ITunesRSSItem) or obj.is_a?(Feedjira::Parser::AtomEntry)
    #puts('[ok parsing now]')
    parse_feedjira_from_yaml(obj, file) # rescue nil # if error silently skip. I mean i have 1000s of news!
  else
    # TODO make this a case/switch when more than 1
    raise "Riccardo, Unknown/unparsable object: #{obj.class}"
  end

end
