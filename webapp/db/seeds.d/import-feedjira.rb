require 'feedjira'
FeedJiraSubdir =  '/../../../crawler/out/feedjira/' # relative to here: db/seeds.d/HERE
dir = File.dirname(__FILE__) + FeedJiraSubdir
raise "doesnt seem a dir: #{dir}" unless Dir.exist?(dir)

def parse_feedjira_from_yaml(jira_feed)
  puts jira_feed
  o = jira_feed
  Article.create(
    title: o.title,
    categories: o.categories, #   + ['2024-03-31', 'feedjira'],
    summary: o.summary,
    summary: (o.content rescue '_NoContent_'),
    guid: o.entry_id, # = guid
    author: o.author,
    link: o.url,
    feed_url: o.url,
    published_date: o.published, # time into date
    active: true,
    ricc_internal_notes: "Imported via #{__FILE__} on #{Time.now}. Content is EMPTY here. Entried: #{o.entries.map{|x| x[0] }.join(',')}. TODO add Newspaper",
    language: 'boh credo inglese',
    image_url: o.image,
    ricc_source: 'feedjira::v1',
    hidden_blurb: o.to_yaml,
  )
end


Dir[File.join(File.dirname(__FILE__), FeedJiraSubdir, '**', '*.yaml')].each_with_index do |file, ix|
  next if ix  > 10
  puts("💾 File ##{ix}: #{ file}")
  #puts("TODO now lets parse the 💩 out of it!")
  obj = YAML.load(File.read(file),
    permitted_classes: [Feedjira::Parser::RSSEntry, Time, Feedjira::Parser::GloballyUniqueIdentifier ]
  )
  if obj.is_a?(Feedjira::Parser::RSSEntry)
    parse_feedjira_from_yaml(obj)
  else
    # TODO make this a case/switch when more than 1
    raise "Unknown/unparsable object: #{obj.class}"
  end

end
