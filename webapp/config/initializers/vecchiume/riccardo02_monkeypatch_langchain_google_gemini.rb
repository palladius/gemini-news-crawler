# frozen_string_literal: true

# Riccardo MonkeyPatching GoogleGemini
module Langchain
  module LLM
    class GoogleGemini
      DEFAULTS ||= {
        chat_completion_model_name: 'gemini-1.5-pro-latest',
        embeddings_model_name: 'textembedding-gecko',
        temperature: 0.2,
        riccardo_notes: 'MonkeyPatched in my Rails code (more portable than local gem. Still barbarian! But hey, I gotta demo to ship)'
      }.freeze

      attr_reader :authorizer

      # TODO(ricc): this can yield an error. Fix the code so its robust and ALWAYS return false if it fails
      # def authenticated?
      #   # TODO(ricc): add if api_key is valid.. but it should work both ways.
      #   # OR starts with /^ya29\./
      #   neha_authenticate() unless defined?(@authorizer)
      #   @authorizer.fetch_access_token!["access_token"].to_s.length == 1024 rescue false # "NEW_NEHA_authenticate()"
      # end
      def authenticated?
        # Attempt Neha authentication first
        begin
          neha_authenticate unless defined?(@authorizer)
          return true if @authorizer.fetch_access_token!['access_token'].to_s.length == 1024
        rescue StandardError => e
          # Handle any exceptions gracefully (log, notify, etc.)
          # You can optionally add specific exception handling here
          Rails.logger.error "Authentication failed with Neha Authentication: #{e.message}"
        end

        # If Neha fails, check for API key validity (replace with your logic)
        # Add your logic to validate the API key here (e.g., compare with a database)
        # return true if your_api_key_validation_logic
        false # Replace with your actual API key validation
      end

      # This function doesnt retrieve the token. But it initializes the @authorizer thru get_application_default
      # which in turn can be called with `fetch_access_token!`
      def neha_authenticate
        # New Neha
        if defined?(@authorizer)
          puts('🐒🐒🐒 Monkeypatching GoogleGemini::neha_authenticate(): Cache HIT! 🐒🐒🐒')
          return @authorizer
        end
        puts('🐒🐒🐒 Monkeypatching GoogleGemini::neha_authenticate(): Cache MISS! 🐒🐒🐒')
        @authorizer = ::Google::Auth.get_application_default([
                                                               'https://www.googleapis.com/auth/cloud-platform',
                                                               'https://www.googleapis.com/auth/generative-language.retriever'
                                                             ])
      end

      def project_id
        ENV.fetch 'PROJECT_ID', 'palladius-genai'
      end

      def embed(
        text:,
        model:   'textembedding-gecko', # "gemini-1.5-pro-latest", # since i cant change DEFAULTS ... @defaults[:embeddings_model_name]
        proj_id: 'palladius-genai', # TODO: ENV['PROJECT_ID']
        region:  'us-central1'
      )
        puts('🐒🐒🐒 Monkeypatching GoogleGemini::embed() and copying from Vertex on gem (ILLEGAL) 🐒🐒🐒')
        params = { instances: [{ content: text }] }

        # or authenticate
        neha_authenticate

        url = "https://#{region}-aiplatform.googleapis.com/v1/projects/#{proj_id}/locations/#{region}/publishers/google/models/"

        uri = URI("#{url}#{model}:predict")

        request = Net::HTTP::Post.new(uri)
        request.content_type = 'application/json'
        request['Authorization'] = "Bearer #{@authorizer.fetch_access_token!['access_token']}"
        request.body = params.to_json

        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
          http.request(request)
        end

        parsed_response = JSON.parse(response.body)

        Langchain::LLM::GoogleGeminiResponse.new(parsed_response, model:)
      end

      def summarize(text:)
        prompt_template = Langchain::Prompt.load_from_path(
          file_path: Langchain.root.join('langchain/llm/prompts/summarize_template.yaml')
        )
        prompt = prompt_template.format(text:)

        neha_authenticate

        complete(
          prompt:,
          temperature: @defaults[:temperature],
          # Most models have a context length of 2048 tokens (except for the newest models, which support 4096).
          max_tokens: 256
        )
      end

       # Generate a chat completion for a given prompt
    #
    # @param messages [Array<Hash>] List of messages comprising the conversation so far
    # @param model [String] The model to use
    # @param tools [Array<Hash>] A list of Tools the model may use to generate the next response
    # @param tool_choice [String] Specifies the mode in which function calling should execute. If unspecified, the default value will be set to AUTO. Possible values: AUTO, ANY, NONE
    # @param system [String] Developer set system instruction
    def chat(params = {})
      params[:system] = {parts: [{text: params[:system]}]} if params[:system]
      params[:tools] = {function_declarations: params[:tools]} if params[:tools]

      raise ArgumentError.new("messages argument is required") if Array(params[:messages]).empty?

      parameters = chat_parameters.to_params(params)
      parameters[:generation_config] ||= {}
      parameters[:generation_config][:temperature] ||= parameters[:temperature] if parameters[:temperature]
      parameters.delete(:temperature)
      parameters[:generation_config][:top_p] ||= parameters[:top_p] if parameters[:top_p]
      parameters.delete(:top_p)
      parameters[:generation_config][:top_k] ||= parameters[:top_k] if parameters[:top_k]
      parameters.delete(:top_k)
      parameters[:generation_config][:max_output_tokens] ||= parameters[:max_tokens] if parameters[:max_tokens]
      parameters.delete(:max_tokens)
      parameters[:generation_config][:response_mime_type] ||= parameters[:response_format] if parameters[:response_format]
      parameters.delete(:response_format)
      parameters[:generation_config][:stop_sequences] ||= parameters[:stop] if parameters[:stop]
      parameters.delete(:stop)

      uri = URI("https://generativelanguage.googleapis.com/v1beta/models/#{parameters[:model]}:generateContent?key=#{api_key}")

      parsed_response = http_post(uri, parameters)

      wrapped_response = Langchain::LLM::GoogleGeminiResponse.new(parsed_response, model: parameters[:model])

      if wrapped_response.chat_completion || Array(wrapped_response.tool_calls).any?
        wrapped_response
      else
        raise StandardError.new(parsed_response)
      end
    end

      #
      # Generate a completion for a given prompt
      #
      # @param prompt [String] The prompt to generate a completion for
      # @param params extra parameters passed to GooglePalmAPI::Client#generate_text
      # @return [Langchain::LLM::GooglePalmResponse] Response object
      #
      # def complete(prompt:, **params)
      #   default_params = {
      #     prompt:,
      #     temperature: @defaults[:temperature],
      #     model: @defaults[:completion_model_name]
      #   }

      #   default_params[:stop_sequences] = params.delete(:stop_sequences) if params[:stop_sequences]

      #   default_params[:max_output_tokens] = params.delete(:max_tokens) if params[:max_tokens]

      #   default_params.merge!(params)

      #   response = client.generate_text(**default_params)

      #   Langchain::LLM::GooglePalmResponse.new response,
      #                                          model: default_params[:model]
      # end

    end

  end
end
