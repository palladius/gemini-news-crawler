
module Langchain
  module LLM
    class GoogleGeminiResponse
          def  output
            puts("[DEBUG] rimuovimi e passa da output a chat_completion cavolone!")
            chat_completion
          end
    end
  end
end

# https://github.com/patterns-ai-core/langchainrb/blob/main/lib/langchain/llm/response/google_gemini_response.rb
# def chat_completion
#   raw_response.dig("candidates", 0, "content", "parts", 0, "text")
# end
