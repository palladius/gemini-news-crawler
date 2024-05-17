
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

end
