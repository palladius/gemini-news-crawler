#!/usr/bin/env ruby

# From: https://github.com/palladius/gemini-news-crawler/pull/1
# Invoke: bundle exec ruby vertex_ai_sample_andrei.rb

require 'langchainrb'
require_relative 'app/tools/article_tool.rb'

raise "Missing GOOGLE_VERTEX_AI_PROJECT_ID" unless ENV.fetch("GOOGLE_VERTEX_AI_PROJECT_ID", nil)
raise "Missing NEWS_API_KEY" unless ENV.fetch("NEWS_API_KEY", nil)


# Instantiate the LLM
llm = Langchain::LLM::GoogleVertexAI.new(project_id: ENV["GOOGLE_VERTEX_AI_PROJECT_ID"], region: "us-central1")
# Create a new Thread to keep track of the messages
thread = Langchain::Thread.new

# Instantiate tools
news_retriever = Langchain::Tool::NewsRetriever.new(api_key: ENV["NEWS_API_KEY"])
article_tool = ArticleTool.new

assistant = Langchain::Assistant.new(
  llm: llm,
  thread: thread,
  instructions: "You are a News Assistant.",
  tools: [news_retriever, article_tool]
)

assistant.add_message_and_run content:"What are the latest news from Google I/O?", auto_tool_execution: true

# Inspect the messages
assistant.thread.messages

assistant.add_message_and_run content:"Save the last one to the database", auto_tool_execution: true
