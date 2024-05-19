module PromptHelper

  def sanitize_news(article)
    sanitized_html = ActionView::Base.full_sanitizer.sanitize(article)
    decoded_text = CGI.unescape_html(sanitized_html)
    return decoded_text
  end


  def rag_short_prompt(date: nil, query: , article_count: )
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

  def rag_long_prompt(date: nil, query: , article_count: , articles: )
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
