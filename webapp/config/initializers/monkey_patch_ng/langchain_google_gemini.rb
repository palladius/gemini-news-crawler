# frozen_string_literal: true
puts('🐒🐒🐒 NG webapp/config/initializers/monkey_patch_ng/langchain_google_gemini.rb 🐒🐒🐒')

puts("")
# Riccardo MonkeyPatching GoogleGemini
module Langchain
  module LLM
    class GoogleGemini

      def authenticated? = true

      def complete(prompt: 'Hi my name is Riccardo and I love Gemin')
        # Thanks Andrei! From https://github.com/patterns-ai-core/langchainrb/blob/main/spec/langchain/llm/google_gemini_spec.rb#L40C21-L40C80
        gemini_messages = [
          {role: "user", parts: [
            {text: prompt}
            ]
          }
        ]
        self.chat(messages: gemini_messages)
      end

    end


    class GoogleVertexAI

      def authenticated? = true

      def complete(prompt: 'Hi my name is Riccardo and I love Verte')
        # Thanks Andrei! From https://github.com/patterns-ai-core/langchainrb/blob/main/spec/langchain/llm/google_gemini_spec.rb#L40C21-L40C80
        gemini_messages = [
          {role: "user", parts: [
            {text: prompt}
            ]
          }
        ]
        self.chat(messages: gemini_messages)
      end

    end

  end
end
