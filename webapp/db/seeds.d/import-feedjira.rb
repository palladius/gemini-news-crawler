require 'feedjira'

MaxArticlesToParse = 4200
FeedJiraSubdir =  '/../../../crawler/out/feedjira/' # relative to here: db/seeds.d/HERE

dir = File.dirname(__FILE__) + FeedJiraSubdir
unless Dir.exist?(dir)
  puts "🎯  ERROR - doesnt seem a dir: #{dir}. Since this could be running in docker - Im gonna scoop the CGB way"
  return
end

def parse_feedjira_from_yaml(jira_feed, file)
  o = jira_feed # less characters :)

  already_exists =  Article.find_by_title(o.title)
  if already_exists
    #puts("🎯 [CACHE HIT] Skipping: '#{o.title}'")
    #print('🎯 [CACHE HIT]')
    return
  else
    puts("🍅 [FRESH NEWS] #{o.published_date.to_date} '#{o.title}'")
  end

  unsafe_feed = YAML.unsafe_load(o.to_yaml) # ["carlessian_info"]
  if unsafe_feed['carlessian_info']
    #puts("🧡 Carlessian info unmarhsalled! WoOOT! #{  unsafe_feed['carlessian_info'] }")
    newspaper = unsafe_feed['carlessian_info']['newspaper']
    macro_region = unsafe_feed['carlessian_info']['macro_region']
  end

  Article.create(
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
end


Dir[File.join(File.dirname(__FILE__), FeedJiraSubdir, '**', '*.yaml')].each_with_index do |file, ix|
  next if ix  > MaxArticlesToParse
  #puts("💾 File ##{ix}: #{ file}")
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
 # case obj.class
    #when Feedjira::Parser::RSSEntry
    if obj.is_a?(Feedjira::Parser::RSSEntry) or obj.is_a?(Feedjira::Parser::ITunesRSSItem) or obj.is_a?(Feedjira::Parser::AtomEntry)
    #puts(obj.class.ancestors)
    #if obj.class.ancestors.include? Feedjira::Parser # https://stackoverflow.com/questions/4545518/test-whether-a-ruby-class-is-a-subclass-of-another-class
        parse_feedjira_from_yaml(obj, file) rescue nil # if error silently skip. I mean i have 1000s of news!
    else
      # TODO make this a case/switch when more than 1
      raise "Riccardo, Unknown/unparsable object: #{obj.class}"
  end

end
