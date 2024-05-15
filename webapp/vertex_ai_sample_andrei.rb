#!/usr/bin/env ruby

# From: https://github.com/palladius/gemini-news-crawler/pull/1
# Invoke: bundle exec ruby vertex_ai_sample_andrei.rb

require 'langchainrb'
require 'googleauth'
#require 'langchainrb'
require_relative 'app/tools/article_tool.rb'
# bundle exec gem install ruby-openai

# It's in lib/monkey_patching/ now :)

# class Langchain::Messages::GoogleGeminiMessage
#   def to_s
#      ...
#   end
# end


# use_openai_instead = !! ENV.fetch('USE_OPENAI_INSTEAD', nil)


# puts("[DEB] Using #{use_openai_instead ? 'OpenAI' : 'Google' }")

raise "Missing GOOGLE_VERTEX_AI_PROJECT_ID" unless ENV.fetch("GOOGLE_VERTEX_AI_PROJECT_ID", nil) # unless use_openai_instead
raise "Missing NEWS_API_KEY" unless ENV.fetch("NEWS_API_KEY", nil)
#if use_openai_instead
#  raise "Missing OPENAI_API_KEY" unless ENV.fetch("OPENAI_API_KEY", nil)
#end


# Instantiate the LLM
llm = Langchain::LLM::GoogleVertexAI.new(project_id: ENV["GOOGLE_VERTEX_AI_PROJECT_ID"], region: "us-central1")
# llm = Langchain::LLM::OpenAI.new(api_key: ENV["OPENAI_API_KEY"])

## Create a new Thread to keep track of the messages
thread = Langchain::Thread.new

# Instantiate tools
news_retriever = Langchain::Tool::NewsRetriever.new(api_key: ENV["NEWS_API_KEY"])
article_tool = ArticleTool.new

assistant = Langchain::Assistant.new(
  llm: llm,
  thread: thread,
  instructions: "You are a News Assistant.",
  #instructions: "You are a News Assistant. You retrieve information and summarize it for people with a hint of humorous approach. You like to add French words randomly to the conversation to give yourself a tone.",
  tools: [news_retriever, article_tool]
)

x = assistant.add_message_and_run content: "What are the latest news from Google I/O?", auto_tool_execution: true
puts(x)
# Inspect the messages
puts assistant.thread.messages

# last message
puts assistant.thread.messages.last.content

assistant.add_message_and_run auto_tool_execution: true, content: "Please show me the titles of the articles in a numbered bullet-point list"
puts assistant.thread.messages # .last.content

if false
  # are you sure?
  assistant.add_message_and_run content:"Save the last one to the database", auto_tool_execution: true
  #assistant.add_message_and_run auto_tool_execution: true, content:"Save the FIRST one to the database"
  #assistant.add_message_and_run content:"Save the Pixel 8A one to the database, and also the one titled 'Google IO 2024 lineup is confirmed'", auto_tool_execution: true
  #assistant.add_message_and_run content:"Fantastic! Can you give me the article IDs of the two?", auto_tool_execution: true
end
