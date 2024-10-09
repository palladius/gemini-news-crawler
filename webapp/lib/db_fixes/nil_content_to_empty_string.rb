# Exec:  cat lib/db_fixes/nil_content_to_empty_string.rb  | rails c
# #
# This is breaking my RAG demo:
#
# #ActiveModel::MissingAttributeError in SmartQueries#show
# Showing /usr/local/google/home/ricc/git/gemini-news-crawler/webapp/app/views/smart_queries/show.html.erb where line #30 raised:

# missing attribute 'content' for Article
# Rails.root: /usr/local/google/home/ricc/git/gemini-news-crawler/webapp

# Application Trace | Framework Trace | Full Trace
#
#
#
# FIX:
#
# 8774 as of 9oct24
bad_articles = Article.where(content: nil).count
puts "[BEFORE] Article.where(content: nil).count : #{bad_articles}"

# exit 42

Article.where(content: nil).each_with_index do |a, ix|
  puts("[#{ix}/] Fixing artcile #{ix} id=#{a.id}")
  #cont = a.content
  a.content = '' #if cont.nil?
  a.save
  break if ix> 15000
end

bad_articles = Article.where(content: nil).count
puts "[AFTER] Article.where(content: nil).count : #{bad_articles}"
