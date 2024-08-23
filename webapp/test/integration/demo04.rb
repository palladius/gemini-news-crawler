# frozen_string_literal: true

# Testing if it works..
llm = Langchain::LLM::GoogleGemini.new(api_key: Rails.application.credentials.env.GEMINI_API_KEY_BIG_QUOTA) # rescue nil # 9xhQ

# Which model are we using?
llm.defaults[:chat_completion_model_name]
# => "gemini-1.5-pro-latest"

@assistant = Langchain::Assistant.new(
  llm:,
  thread: Langchain::Thread.new,
  instructions: 'You are a News Assistant.',
  # You can iterate and program your assistant based on your preferences.
  # instructions: "You are a News Assistant. When prompted for further info about some news, dont call further functions; instead show the JSON of the matching article - if there's one.",
  tools: [
    NewsRetriever, # 🔧 instantiated in config/initializers/
    ArticleTool.new # 🔧 instantiating now. Code in: https://github.com/palladius/gemini-news-crawler/blob/main/webapp/app/tools/article_tool.rb
  ]
)

#def s(str) = @assistant.say(str)

# VERBOSE: puts(@assistant.add_message_and_run(content: 'Latest 5 news from Italy', auto_tool_execution: true))
# SHORT:   s 'Latest 5 news from Italy'

@assistant.say 'Latest 5 news from Italy'

# returns an array of messages
puts(@assistant.history)
