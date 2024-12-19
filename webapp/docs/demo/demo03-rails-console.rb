# frozen_string_literal: true

# This demo is also visible in here:
# * [dev] https://gemini-news-crawler-dev-x42ijqglgq-ew.a.run.app/pages/demo-news-retriever
# * [PRD] https://gemini-news-crawler-dev-x42ijqglgq-ew.a.run.app/pages/demo-news-retriever


#query = 'Vinitaly'
#query = 'Balsamic Vinegar'
#query = 'Arrosticini'
query = 'Swiss bunkers'

# available to rails, but NOT to this script :)
helpz = ApplicationController.helpers

# As we say in Italian, `the eye wants its part`.
def print_colorful_to_console(article)
  # article dug through NewsRetriever
  puts('-------------------------------------------')
  puts("📰📰📰 #{article['title'].colorize :yellow} 📰📰📰")
  puts('')
  puts(article['description'].colorize(:cyan))
  puts(article['content'].colorize(:green))
  puts('')
  puts("📰 url: #{article['url'].colorize :white}")
  puts("📰 publishedAt: #{article['publishedAt'].to_date.to_s.colorize :white}")
  puts("📰 Source.name: #{article.dig('source', 'name').colorize :white}")
  puts('-------------------------------------------')
end

# JFYI
# NewsRetriever = Langchain::Tool::NewsRetriever.new(api_key: (Rails.application.credentials.env.fetch(:NEWSAPI_COM_KEY, nil) rescue "error #{$!}") )

news = NewsRetriever.get_everything(q: query, page_size: 6).to_s.force_encoding('UTF-8')
cmd = "NewsRetriever.get_everything(q: '#{query}', page_size: 6)"
parsed_json = JSON.parse(news)
cmd_and_news = "# 💻 #{cmd} (excerpt)\n\n#{helpz.render_json(news).first(500)}.."
puts(cmd_and_news)

# prints first article in colorful way
first_article = parsed_json['articles'][0]
print_colorful_to_console(first_article)
