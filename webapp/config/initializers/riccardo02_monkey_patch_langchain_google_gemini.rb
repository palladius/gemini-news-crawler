
# Riccardo MonkeyPatching GoogleGemini
class Langchain::LLM::GoogleGemini
  DEFAULTS ||= {
    chat_completion_model_name: "gemini-1.5-pro-latest",
    embeddings_model_name: "textembedding-gecko",
    temperature: 0.2,
    riccardo_notes: "MonkeyPatched in my Rails code (more portable than local gem. Still barbarian! But hey, I gotta demo to ship)",
  }

  attr_reader :authorizer

  def authenticated?
    # TODO(ricc): add if api_key is valid.. but it should work both ways.
    # OR starts with /^ya29\./
    neha_authenticate unless defined?(@authorizer)
    @authorizer.fetch_access_token!["access_token"].to_s.length == 1024 rescue "NEW_NEHA_authenticate()"
  end

  # This function doesnt retrieve the token. But it initializes the @authorizer thru get_application_default
  # which in turn can be called with `fetch_access_token!`
  def neha_authenticate
    #New Neha
    if defined?(@authorizer)
      puts("🐒🐒🐒 Monkeypatching GoogleGemini::neha_authenticate(): Cache HIT! 🐒🐒🐒")
      return @authorizer
    end
    puts("🐒🐒🐒 Monkeypatching GoogleGemini::neha_authenticate(): Cache MISS! 🐒🐒🐒")
    @authorizer = ::Google::Auth.get_application_default([
        "https://www.googleapis.com/auth/cloud-platform",
        "https://www.googleapis.com/auth/generative-language.retriever"
      ])
  end

  def project_id
    ENV.fetch 'PROJECT_ID', 'palladius-genai'
  end

  def embed(
    text:,
    model:   "textembedding-gecko", # "gemini-1.5-pro-latest", # since i cant change DEFAULTS ... @defaults[:embeddings_model_name]
    proj_id: "palladius-genai", # TODO  ENV['PROJECT_ID']
    region:  'us-central1'
  )
    puts("🐒🐒🐒 Monkeypatching GoogleGemini::embed() and copying from Vertex on gem (ILLEGAL) 🐒🐒🐒")
    params = {instances: [{content: text}]}

    # or authenticate
    neha_authenticate()

    url = "https://#{region}-aiplatform.googleapis.com/v1/projects/#{proj_id}/locations/#{region}/publishers/google/models/"

    uri = URI("#{url}#{model}:predict")

    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer #{@authorizer.fetch_access_token!["access_token"]}"
    request.body = params.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end

    parsed_response = JSON.parse(response.body)

    Langchain::LLM::GoogleGeminiResponse.new(parsed_response, model: model)
  end

  def summarize(text:)
    prompt_template = Langchain::Prompt.load_from_path(
      file_path: Langchain.root.join("langchain/llm/prompts/summarize_template.yaml")
    )
    prompt = prompt_template.format(text: text)

    neha_authenticate()

    complete(
      prompt: prompt,
      temperature: @defaults[:temperature],
      # Most models have a context length of 2048 tokens (except for the newest models, which support 4096).
      max_tokens: 256
    )
  end

    #
    # Generate a completion for a given prompt
    #
    # @param prompt [String] The prompt to generate a completion for
    # @param params extra parameters passed to GooglePalmAPI::Client#generate_text
    # @return [Langchain::LLM::GooglePalmResponse] Response object
    #
    def complete(prompt:, **params)
      default_params = {
        prompt: prompt,
        temperature: @defaults[:temperature],
        model: @defaults[:completion_model_name]
      }

      if params[:stop_sequences]
        default_params[:stop_sequences] = params.delete(:stop_sequences)
      end

      if params[:max_tokens]
        default_params[:max_output_tokens] = params.delete(:max_tokens)
      end

      default_params.merge!(params)

      response = client.generate_text(**default_params)

      Langchain::LLM::GooglePalmResponse.new response,
        model: default_params[:model]
    end

end
