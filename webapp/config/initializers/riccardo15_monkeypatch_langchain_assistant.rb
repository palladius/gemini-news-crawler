# frozen_string_literal: true

# This is just syntactic sugar for demo04.

module Langchain
  class Assistant
    # just syntactic sugar as i dont want to type 20 times this and grow a beard:
    #  @assistant.add_message_and_run( content: 'Please also save the Magnotta winery article too', auto_tool_execution: true)
    #  => @assistant.say 'Please also save the Magnotta winery article too'
    # , also_show_latest_message: true)
    def say(msg)
      add_message_and_run(content: msg, auto_tool_execution: true)
      puts  thread.messages.last(2)
      nil # if I return ret, it will bloat the output!
    end

    def history
      puts thread.messages
    end

    # manages Net::HTTPTooManyRequests:0x0000000116c34940 -> sleep 10 and retry.
    def user_loop
      puts("Use: 'history' to get chat history or 'exit' to exit.")
      prompt = '>>> '
      while (user_input = gets.chomp) # loop while getting user input
        case user_input
        when ''
          puts('[#5] 🤖 I need input!')
          break # make sure to break so you don't ask again
        when 'history'
          history
          break # make sure to break so you don't ask again
        when 'exit'
          puts 'Looks like you wanna exit, fine by me.'
          return
        else
          # puts "Please select either 1 or 2"
          say(user_input.strip)
          # print prompt # print the prompt, so the user knows to re-enter input
          print prompt # print the prompt, so the user knows to re-enter input
        end
      end
    end
  end
end
