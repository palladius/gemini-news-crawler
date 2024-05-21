
# This demo is a lot better run in the console than on web, given its interactive aspect.



# # Nice visualizer for the chat -> added to riccardo05_monkeypatch
# class Langchain::Messages::GoogleGeminiMessage
#   def to_s
#     # 💬
#     # fun call
#     if self.tool_calls.any?
#       return self.tool_calls.enum_for(:each_with_index).map {|tool_call,ix|
#         return "🤖 [#{role}] 🛠️ [#{ix+1}/#{self.tool_calls.count}] 🛠️  #{tool_call['functionCall'].to_s.force_encoding("UTF-8").colorize(:gray) rescue $!}"
#     }.join("\n") # test, should just be "\n"
#   end
#     # model
#     return "🤖 [#{role}] 💬 #{self.content.force_encoding("UTF-8").strip.colorize :cyan}" if role == 'model'
#     # user
#     return "🧑 [#{role}] 💬 #{self.content.force_encoding("UTF-8").colorize :yellow}" if role == 'user'
#     # function
#     return "🤖 [#{role}] 🛠️  #{self.tool_call_id.force_encoding("UTF-8").colorize :red} => #{self.content.force_encoding("UTF-8").colorize :green}" if role == 'function'
#     # if everything else fails...
#     return self.inspect # :status, :code, :messafe, ...
#   end
# end

class Langchain::Assistant

  # just syntactic sugar as i dont want to type 20 times this and grow a beard:
  #  @assistant.add_message_and_run( content: 'Please also save the Magnotta winery article too', auto_tool_execution: true)
  #  => @assistant.say 'Please also save the Magnotta winery article too'
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

  def user_loop()
    puts("Use: 'history' to get chat history or 'exit' to exit.")
    prompt = ">>> "
    while user_input = gets.chomp # loop while getting user input
      case user_input
        when ""
          puts('[#5] 🤖 I need input!')
          break # make sure to break so you don't ask again
        when "history"
          self.history
          break # make sure to break so you don't ask again
        when "exit"
          puts "Looks like you wanna exit, fine by me."
          return
        else
          #puts "Please select either 1 or 2"
          say(user_input.strip)
          #print prompt # print the prompt, so the user knows to re-enter input
          print prompt # print the prompt, so the user knows to re-enter input
        end
    end
  end
end

@query ||= 'Latest 7 news from Italy'

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


# Now its time to improvise a bit. Ask an additional question..
@assistant.say 'Tell me more about the asian news'
# @asistant.history
@assistant.say 'Save this the first two articles please'
@assistant.history
@assistant.say 'Save this the LAST two articles please'

# interact directly
@assistant.user_loop
