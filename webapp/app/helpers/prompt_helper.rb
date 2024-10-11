# frozen_string_literal: true

module PromptHelper

  def sanitize_news(article)
    # mi sa che a volte questa e una stringa, non un oggetto. Vabbeh
    raise "Need an article!" unless article.is_a?(Article)
    #return article.to_s if article.is_a?(String)
    #article.content = '' if article.content.blank?
    # presence: https://stackoverflow.com/questions/19212140/what-is-the-best-way-to-check-if-an-attribute-exists-and-is-set
    article.content = '[not present]' unless article.content.presence

    sanitized_html = ActionView::Base.full_sanitizer.sanitize(article) rescue "Sanitization error for #{article}: #{$!}"
    CGI.unescape_html(sanitized_html)
  end

  # A volte lo chiamo x articolo a volte per stringa.
  # inputL: string
  # output: string (sanitized)
  def sanitize_article_excerpt(article_excerpt)
    raise "Need a string" unless article_excerpt.is_a?(String)
    #return article_excerpt.to_s if article_excerpt.is_a?(String)
    sanitized_html = ActionView::Base.full_sanitizer.sanitize(article_excerpt) rescue "Sanitization error for #{article_excerpt}: #{$!}"
    CGI.unescape_html(sanitized_html)
  end

  def rag_short_prompt(query:, article_count:, date: nil)
    date ||= Date.today
    @short_prompt = <<~HEREDOC
      You are a prompt summarizer called Helper::rag_short_prompt.
      You need to answer this user query: '''#{query}''' after reading the following articles which seem the most pertinent.
      Pay attention to the recency of the articles, since the date of articles is provided. Note: More recent is better.

      Date of today: #{date}
      Query: '#{query}'

      Here are the #{article_count} Articles:
    HEREDOC
  end

  def rag_long_prompt(query:, article_count:, articles:, date: nil)
    date ||= Date.today

    @long_prompt = <<~HEREDOC
      You are a prompt summarizer called Helper::rag_long_prompt.
      You need to answer this user query: '''#{query}''' after reading the following articles which seem the most pertinent.
      Pay attention to the recency of the articles, since the date of articles is provided. Note: More recent is better.

      Date of today: #{date}
      Query: '#{query}'

      Here are the #{article_count} Articles:
      ---------------
      #{sanitize_news articles}
      ---------------
      Summary of articles regarding '#{query}':
    HEREDOC
    @long_prompt
  end
end
