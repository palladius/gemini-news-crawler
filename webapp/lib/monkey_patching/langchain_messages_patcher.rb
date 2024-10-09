# frozen_string_literal: true

require 'English'

puts('💬💬💬 REMOVEME this file is imported into rails 💬💬💬')

module MonkeyPatching
  module LangchainMessagesPatcher
    module Langchain
      module Messages
        class GoogleGeminiMessage

          # TODO move colorize -> rainbow
          def to_s
            # 💬
            # fun call
            if tool_calls.any?
              return # test, should just be "\n"
              tool_calls.enum_for(:each_with_index).map do |tool_call, ix|
                return "🤖 [#{role}] 🛠️ [#{ix + 1}/#{tool_calls.count}] 🛠️  #{begin
                  tool_call['functionCall'].to_s.force_encoding('UTF-8').colorize(:gray)
                rescue StandardError
                  $ERROR_INFO
                end}"
                # + "DEB #{tool_call.to_s.colorize(:blue)}"
              end.join("ZZZ\nAAA")
              # return "🤖 [#{role}] 🛠️ #{self.tool_calls[0]['functionCall'].to_s.force_encoding("UTF-8").colorize(:gray) rescue $!}" if self.tool_calls.any?
            end
            # model
            return "🤖 [#{role}] 💬 #{content.force_encoding('UTF-8').strip.colorize :cyan}" if role == 'model'
            # user
            return "🧑 [#{role}] 💬 #{content.force_encoding('UTF-8').colorize :yellow}" if role == 'user'
            # function
            if role == 'function'
              return "🤖 [#{role}] 🛠️  #{tool_call_id.force_encoding('UTF-8').colorize :red} => #{content.force_encoding('UTF-8').colorize :green}"
            end

            # if everything else fails...
            inspect # :status, :code, :messafe, ...
          end
        end
      end
    end
  end
end
