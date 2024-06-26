#!/usr/bin/env ruby
# frozen_string_literal: true

# From: https://github.com/palladius/gemini-news-crawler/pull/1
# Invoke: bundle exec ruby vertex_ai_sample_andrei.rb
# Invoke:
#            cat  vertex_ai_sample_andrei.rb | rails c
#

# require 'langchainrb'
# require 'googleauth'
# #require 'langchainrb'
# require_relative 'app/tools/article_tool.rb'
# require_relative 'lib/monkey_patching/langchain_messages_patcher'
include MonkeyPatching::LangchainMessagesPatcher

# puts MonkeyPatching # ::LangchainMessagesPatcher::Langchain::Messages::GoogleGeminiMessage

# It's in lib/monkey_patching/ now :)

# include MonkeyPatching::LangchainMessagesPatcher
# class Langchain::Messages::GoogleGeminiMessage
#   def to_s
#      ...
#   end
# end

# use_openai_instead = !! ENV.fetch('USE_OPENAI_INSTEAD', nil)

# puts("[DEB] Using #{use_openai_instead ? 'OpenAI' : 'Google' }")

# unless use_openai_instead
raise 'Missing GOOGLE_VERTEX_AI_PROJECT_ID' unless ENV.fetch('GOOGLE_VERTEX_AI_PROJECT_ID', nil)
raise 'Missing NEWS_API_KEY' unless ENV.fetch('NEWS_API_KEY', nil)

# if use_openai_instead
#  raise "Missing OPENAI_API_KEY" unless ENV.fetch("OPENAI_API_KEY", nil)
# end

# Instantiate the LLM
llm = Langchain::LLM::GoogleVertexAI.new(
  project_id: ENV['GOOGLE_VERTEX_AI_PROJECT_ID'],
  region: 'us-central1',
  default_options: {
    chat_completion_model_name: 'gemini-1.5-pro-latest'
  }
)
# llm = Langchain::LLM::OpenAI.new(api_key: ENV["OPENAI_API_KEY"])

## Create a new Thread to keep track of the messages
thread = Langchain::Thread.new

# Instantiate tools
news_retriever = Langchain::Tool::NewsRetriever.new(api_key: ENV['NEWS_API_KEY'])
article_tool = ArticleTool.new

assistant = Langchain::Assistant.new(
  llm:,
  thread:,
  instructions: 'You are a News Assistant.',
  # instructions: "You are a News Assistant. You retrieve information and summarize it for people with a hint of humorous approach. You like to add French words randomly to the conversation to give yourself a tone.",
  tools: [news_retriever, article_tool]
)

x = assistant.add_message_and_run content: 'What are the latest news from Google I/O?', auto_tool_execution: true
puts(x)
# Inspect the messages
puts assistant.thread.messages

# last message
puts assistant.thread.messages.last.content

# assistant.add_message_and_run auto_tool_execution: true, content: "Please show me the titles of the articles in a numbered bullet-point list"
# puts assistant.thread.messages # .last.content

if false
  # are you sure?
  assistant.add_message_and_run content: 'Save the last article to the database', auto_tool_execution: true
  # assistant.add_message_and_run auto_tool_execution: true, content:"Save the FIRST one to the database"
  # assistant.add_message_and_run content:"Save the Pixel 8A one to the database, and also the one titled 'Google IO 2024 lineup is confirmed'", auto_tool_execution: true
  # assistant.add_message_and_run content:"Fantastic! Can you give me the article IDs of the two?", auto_tool_execution: true
end
