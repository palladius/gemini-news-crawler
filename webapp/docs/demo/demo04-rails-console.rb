
# This demo is a lot better run in the console than on web, given its interactive aspect.



# Nice visualizer for the chat
class Langchain::Messages::GoogleGeminiMessage
  def to_s
    # 💬
    # fun call
    if self.tool_calls.any?
      return self.tool_calls.enum_for(:each_with_index).map {|tool_call,ix|
        return "🤖 [#{role}] 🛠️ [#{ix+1}/#{self.tool_calls.count}] 🛠️  #{tool_call['functionCall'].to_s.force_encoding("UTF-8").colorize(:gray) rescue $!}"
    }.join("\n") # test, should just be "\n"
  end
    # model
    return "🤖 [#{role}] 💬 #{self.content.force_encoding("UTF-8").strip.colorize :cyan}" if role == 'model'
    # user
    return "🧑 [#{role}] 💬 #{self.content.force_encoding("UTF-8").colorize :yellow}" if role == 'user'
    # function
    return "🤖 [#{role}] 🛠️  #{self.tool_call_id.force_encoding("UTF-8").colorize :red} => #{self.content.force_encoding("UTF-8").colorize :green}" if role == 'function'
    # if everything else fails...
    return self.inspect # :status, :code, :messafe, ...
  end
end

class Langchain::Assistant
  # just syntactis sugar as i dont want to type 20 times
  # @assistant.add_message_and_run( content: 'Please also save the Magnotta winery article too', auto_tool_execution: true)
  # @assistant.add_message_and_run( content: 'Please also save the Magnotta winery article too', auto_tool_execution: true)
  def say(msg, also_show_latest_message: true)
    #Langchain::Assistant
    #puts self.thread.messages.last # (2)
    ret = self.add_message_and_run( content: msg, auto_tool_execution: true)
    if also_show_latest_message
      puts self.thread.messages.last(2)
      #puts self.thread.messages.last # (2)
    end
    return nil
    # ret
  end

  def history()
    puts self.thread.messages
  end
end

@query ||= 'Latest 7 news from Vinitaly'

# llm = Langchain::LLM::GoogleVertexAI.new(project_id: ENV["GOOGLE_VERTEX_AI_PROJECT_ID"], region: "us-central1")

#llm = VertexLLM # doesnt work
llm = GeminiLLM # does work

thread = Langchain::Thread.new

# Creating tools to feed the Assistant
news_retriever  = NewsRetriever # instantiated in config/initializers/
article_tool = ArticleTool.new  # doing now


@assistant = Langchain::Assistant.new(
  llm: llm,
  thread: thread,
  instructions: "You are a News Assistant.",
  tools: [news_retriever, article_tool]
)

# returns an array of messages
@first_iteration = @assistant.add_message_and_run( content: @query, auto_tool_execution: true)
puts(@first_iteration)
puts(thread.messages)


# Now its time to improvise a bit
@assistant.say 'Tell me more about the asian news'
@asistant.history
