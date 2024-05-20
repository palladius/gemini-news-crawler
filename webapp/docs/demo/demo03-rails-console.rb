
# This demo is also visible in here:
# * [dev] https://gemini-news-crawler-dev-x42ijqglgq-ew.a.run.app/pages/demo-news-retriever
# * [PRD] https://gemini-news-crawler-dev-x42ijqglgq-ew.a.run.app/pages/demo-news-retriever

# available to rails, but NOT to this script :)
helpz = ApplicationController.helpers

# As we say in Italian, `the eye wants its part`.
def print_colorful_to_console(article)
  # article dug through NewsRetriever
  puts('-------------------------------------------')
  puts("📰📰📰 #{article.dig( 'title').colorize :yellow } 📰📰📰")
  puts("")
  puts("#{article.dig( 'description').colorize :cyan}")
  puts("#{article.dig( 'content').colorize :green}")
  puts("")
  puts("📰 url: #{article.dig( 'url').colorize :white}")
  puts("📰 publishedAt: #{article.dig('publishedAt').to_date.to_s.colorize :white}")
  puts("📰 Source.name: #{article.dig( 'source', 'name').colorize :white}")
  puts('-------------------------------------------')
end

query = 'Vinitaly'
news = NewsRetriever.get_everything( q: query).to_s.force_encoding("UTF-8")
cmd = "NewsRetriever.get_everything( q: '#{query}')"
parsed_json = JSON.parse(news)
cmd_and_news = "# 💻 #{cmd} (excerpt)\n\n#{helpz.render_json(news).first(500)}.."

puts(cmd_and_news)

first_article = parsed_json['articles'][0]

print_colorful_to_console(first_article)
