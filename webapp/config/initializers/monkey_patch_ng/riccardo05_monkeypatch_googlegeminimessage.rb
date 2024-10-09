# frozen_string_literal: true

require 'English'

module Langchain
  module Messages
    class GoogleGeminiMessage
      def to_s
        # 💬
        # fun call
        if tool_calls.any?
          # for every tool_calls print one line:
          # 🤖 [model] 🛠️ [1/2] 🛠️  {"name"=>"news_retriever__get_top_headlines", ..
          # 🤖 [model] 🛠️ [2/2] 🛠️  {"name"=>"....",
          tool_calls.enum_for(:each_with_index).map do |tool_call, ix|
            return "🤖 [#{role}] 🛠️ [#{ix + 1}/#{tool_calls.count}] 🛠️  #{begin
              tool_call['functionCall'].to_s.force_encoding('UTF-8').colorize(:gray)
            rescue StandardError
              $ERROR_INFO
            end}"
          end.join("\n")
          # return "🤖 [#{role}] 🛠️ #{self.tool_calls[0]['functionCall'].to_s.force_encoding("UTF-8").colorize(:gray) rescue $!}" if self.tool_calls.any?
        end

        redaction_length = 3000
        sanitized_content = content.force_encoding('UTF-8').strip
        if sanitized_content.length > redaction_length
          sanitized_content = "#{sanitized_content.first(redaction_length)}.. (🤥 redacted)"
        end

        # model
        return "🤖 [#{role}] 💬 #{sanitized_content.colorize :cyan}" if role == 'model'
        # user
        return "🧑 [#{role}] 💬 #{sanitized_content.colorize :yellow}" if role == 'user'
        # function 🖩 would be great but too small 🧮 this is nice
        if role == 'function'
          return "🔢➡️🔢 [#{role}] 🛠️  #{tool_call_id.force_encoding('UTF-8').colorize :white} => #{sanitized_content.colorize :gray}"
        end

        # if everything else fails...
        inspect # :status, :code, :messafe, ...
      end
    end
  end
end
