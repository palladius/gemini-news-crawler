# This demo is a lot better run in the console than on web, given its interactive aspect.

# Nice visualizer for the chat -> moved to riccardo05_monkeypatch
# Nice patch of assistant: moved to `webapp/config/initializers/riccardo15_monkeypatch_langchain_assistant.rb`

#@query ||= 'Latest 5 news from Italy'

# llm = Langchain::LLM::GoogleVertexAI.new(project_id: ENV["GOOGLE_VERTEX_AI_PROJECT_ID"], region: "us-central1")

#llm = VertexLLM # doesnt work
#llm = GeminiLLM # TODO - move to above

llm  = Langchain::LLM::GoogleGemini.new(api_key: Rails.application.credentials.env.GEMINI_API_KEY_BIG_QUOTA)# rescue nil # 9xhQ

thread = Langchain::Thread.new

# Creating tools to feed the Assistant
#news_retriever  = NewsRetriever # instantiated in config/initializers/
#article_tool = ArticleTool.new  # doing now


@assistant = Langchain::Assistant.new(
  llm: llm,
  thread: thread,
  instructions: "You are a News Assistant.",
  tools: [
    NewsRetriever,     # instantiated in config/initializers/
    ArticleTool.new ,  # instantiating now
  ]
)

# returns an array of messages
@assistant.add_message_and_run(content: 'Latest 5 news from Italy', auto_tool_execution: true)
#puts(thread.messages)
@assistant.history

@assistant.say 'how many results did the API call return?'
# 🤖 [model] 💬 The API call returned 34 results.

# Now its time to improvise a bit. Ask an additional question..
@assistant.say 'Tell me more about the asian news'
# @asistant.history
@assistant.say 'Save this the first two articles please'
@assistant.history
# Provides with the Cloud Run app url.
@assistant.say 'Thanks. Provide me with the Carlessian URL for the article you just saved please'

@assistant.say 'Save this the LAST two articles please'

# interact directly
@assistant.user_loop
