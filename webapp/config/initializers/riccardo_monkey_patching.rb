puts("🐒🐒🐒 webapp/config/initializers/riccardo_monkey_patching.rb 🐒🐒🐒")

# Monkeypatching the CHAT because I need to use Gemini URI and Vertex Auth. In reality I need some kind of hybrid
# thingy.
#
# == GoogleVertexAI ==
# 3 changes need to happen to make GoogleVertexAI work with Gemini functions:
#   1. Add the two scopes to Auth. This fixes authenticaiton both for GCP and for consumer api key.
#      This is in LATEST but not in the gem, so I have to re-code it in this `initialize()`
#   2. Add Gemini URL `generativelanguage.googleapis.com`. This forces me to monkey-patch `chat()`
#   3. Add Gemini 1.5/. This requires no refactoring - I just changed the constructor in
#      `webapp/vertex_ai_sample_andrei.rb`. I still cant understand why this wont work with Gemini 1.0
#      when docs says it works fine.
#  Let's see if the Zeitgeist gets angry at this MonkeyPatching.
#
#  Plus, if youw ant GeminiLLM to calculate embeddings, it cannot. You either need VertexLLM OR you can just monkeypatch
#  the same function. In this case, though, you need to also add  embeddings_model_name: "textembedding-gecko" to
#   DEFAULTS = { .. }
#
# == GoogleGemini ==
# Had to change the embed..
#

class Langchain::LLM::GoogleVertexAI

  # This needs to be redefined because, even though Andrei pushed this commit, its not in gem v0.3.21
  # https://github.com/patterns-ai-core/langchainrb/blob/main/lib/langchain/llm/google_vertex_ai.rb
  # commit: https://github.com/patterns-ai-core/langchainrb/commit/dcb6078041ae8af4ff147d650d18ea71ac02d759
  def initialize(project_id:, region:, default_options: {})
    depends_on "googleauth"

    #################################################################
    # Riccardo begin
    puts("🐒🐒🐒 Riccardo GoogleVertexAI::init on Mac 🐒🐒🐒")
  #      @authorizer = ::Google::Auth.get_application_default
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/generative-language.retriever"
    ]
    # @authorizer = Google::Auth::GCECredentials.on_gce?  ?
    #   # GCE - wont accept the scopes. Will fail with
    #   #   raise TypeError, "Expected Array or String, got #{new_scope.class}"
    #   ::Google::Auth.get_application_default(scope=scopes) :
    #   # non GCE - will accept the scopes
    #   ::Google::Auth.get_application_default(scope: scopes)
    #   #################################################################
    # Neha fix
    @authorizer = ::Google::Auth.get_application_default(scopes)


    proj_id = project_id || @authorizer.project_id || @authorizer.quota_project_id
    @url = "https://#{region}-aiplatform.googleapis.com/v1/projects/#{proj_id}/locations/#{region}/publishers/google/models/"

    @defaults = DEFAULTS.merge(default_options)

    chat_parameters.update(
      model: {default: @defaults[:chat_completion_model_name]},
      temperature: {default: @defaults[:temperature]}
    )
    chat_parameters.remap(
      messages: :contents,
      system: :system_instruction,
      tool_choice: :tool_config
    )
  end

  def chat(params = {})
      puts("🐒🐒🐒 Monkeypatching GoogleVertexAI::chat() on my repo 🐒🐒🐒")

      params[:system] = {parts: [{text: params[:system]}]} if params[:system]
      params[:tools] = {function_declarations: params[:tools]} if params[:tools]
      # This throws an error when tool_choice is passed
      params[:tool_choice] = {function_calling_config: {mode: params[:tool_choice].upcase}} if params[:tool_choice]
      # chat_url = params.fetch(:url, url)

      raise ArgumentError.new("messages argument is required") if Array(params[:messages]).empty?

      parameters = chat_parameters.to_params(params)
      parameters[:generation_config] = {temperature: parameters.delete(:temperature)} if parameters[:temperature]

      # RiccardoMac start
      url = 'https://generativelanguage.googleapis.com/v1beta/models/'
      # RiccardoMac end
      uri = URI("#{url}#{parameters[:model]}:generateContent")

      request = Net::HTTP::Post.new(uri)
      request.content_type = "application/json"
      request["Authorization"] = "Bearer #{@authorizer.fetch_access_token!["access_token"]}"
      request.body = parameters.to_json

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
        http.request(request)
      end

      parsed_response = JSON.parse(response.body)

      wrapped_response = Langchain::LLM::GoogleGeminiResponse.new(parsed_response, model: parameters[:model])

      if wrapped_response.chat_completion || Array(wrapped_response.tool_calls).any?
        wrapped_response
      else
        # Riccardo
        if response.is_a?(Net::HTTPBadRequest)
          puts("🐒🐒🐒 Monkeypatching response GoogleVertexAI::chat on my repo 🐒🐒🐒")
          puts("🐒🐒🐒 response.inspect=#{response.inspect} 🐒🐒🐒")
        end
        #puts("🍏🍏🍏 Riccardo Vertex::chat on Mac 🍏🍏🍏")
        raise StandardError.new(response)
      end
    end

end





class Langchain::LLM::GoogleGemini
  DEFAULTS = {
    chat_completion_model_name: "gemini-1.5-pro-latest",
    embeddings_model_name: "textembedding-gecko",
    temperature: 0.2,
    riccardo_notes: "MonkeyPatched in my Rails code (more portable than local gem. Still barbarian! But hey, I gotta demo to ship)",
  }

  #attr_reader :url

  def embed(
    text:,
    model:   "textembedding-gecko", # "gemini-1.5-pro-latest", # since i cant change DEFAULTS ... @defaults[:embeddings_model_name]
    proj_id: "palladius-genai", # TODO  ENV['PROJECT_ID']
    region:  'us-central1'
  )
    puts("🐒🐒🐒 Monkeypatching GoogleGemini::embed() and copying from Vertex on gem (ILLEGAL) 🐒🐒🐒")
    params = {instances: [{content: text}]}

    @authorizer = ::Google::Auth.get_application_default(scope: [
        "https://www.googleapis.com/auth/cloud-platform",
        "https://www.googleapis.com/auth/generative-language.retriever"
      ])

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


class Google::Auth::GCECredentials
  def project_id
    'palladius-genai' # TODO move to ENV[] ma lo posso testare solo a manhouse..
  end
end
