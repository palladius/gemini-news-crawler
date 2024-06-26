# frozen_string_literal: true

# Riccardo MonkeyPatching GoogleGemini
require 'English'
module Langchain
  module LLM
    class GooglePalm
      # pairs well with => Langchain::LLM::GooglePalmResponse.output()
      def sample_complete
        complete(
          prompt: 'Please write a night-time story about the evil Amarone-wine daemon who lived in Arena di Verona. He was a part-time Ruby on rails developer who at night went scaring tourists, particularly the ones who saw the Netflix movie "Love in the villa". Use as many emojis as you can and make it fun and add some Italian drama twist to it.', max_output_tokens: 1024, temperature: 0.5
        )
      end

      def summarize_with_tokens(text:, max_tokens: 256, temperature: nil)
        # Riccardo monkeypatching.
        prompt_template = Langchain::Prompt.load_from_path(
          file_path: Langchain.root.join('langchain/llm/prompts/summarize_template.yaml')
        )
        prompt = prompt_template.format(text:)

        temperature ||= @defaults[:temperature]

        complete(
          prompt:,
          temperature:,
          # Most models have a context length of 2048 tokens (except for the newest models, which support 4096).
          max_tokens:
        )
      end

      # client.list_models
      # =>
      # {"models"=>
      #   [{"name"=>"models/chat-bison-001",
      #     "version"=>"001",
      #     "displayName"=>"PaLM 2 Chat (Legacy)",
      #     "description"=>"A legacy text-only model optimized for chat conversations",
      #     "inputTokenLimit"=>4096,
      #     "outputTokenLimit"=>1024,
      #     "supportedGenerationMethods"=>["generateMessage", "countMessageTokens"],
      #     "temperature"=>0.25,
      #     "topP"=>0.95,
      #     "topK"=>40},
      #    {"name"=>"models/text-bison-001",
      #     "version"=>"001",
      #     "displayName"=>"PaLM 2 (Legacy)",
      #     "description"=>"A legacy model that understands text and generates text as an output",
      #     "inputTokenLimit"=>8196,
      #     "outputTokenLimit"=>1024,
      #     "supportedGenerationMethods"=>["generateText", "countTextTokens", "createTunedTextModel"],
      #     "temperature"=>0.7,
      #     "topP"=>0.95,
      #     "topK"=>40},
      #    {"name"=>"models/embedding-gecko-001",
      #     "version"=>"001",
      #     "displayName"=>"Embedding Gecko",
      #     "description"=>"Obtain a distributed representation of a text.",
      #     "inputTokenLimit"=>1024,
      #     "outputTokenLimit"=>1,
      #     "supportedGenerationMethods"=>["embedText", "countTextTokens"]}]}

      def authenticated?
        # :boh
        # i cant auth but thjis returns an API call so its a good thing

        client.list_models.key?('models')
      rescue StandardError
        false
      end
    end
  end
end

module Langchain
  module LLM
    class GooglePalmResponse
      def output
        # raw_response.dig("candidates").dig(0, "output")
        raw_response.dig('candidates', 0, 'output')
      end

      def error
        raw_response['error']
      end

      def meaningful_response
        begin
          output || error
        rescue StandardError
          "Langchain::LLM::GooglePalmResponse.meaningful_response Exception: #{$ERROR_INFO}"
        end.to_s
      end
    end
  end
end
