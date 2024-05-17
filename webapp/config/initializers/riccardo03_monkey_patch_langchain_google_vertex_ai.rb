
class Langchain::LLM::GoogleVertexAI

  # TODO move default scopes to a @@variable.

  # This needs to be redefined because, even though Andrei pushed this commit, its not in gem v0.3.21
  # https://github.com/patterns-ai-core/langchainrb/blob/main/lib/langchain/llm/google_vertex_ai.rb
  # commit: https://github.com/patterns-ai-core/langchainrb/commit/dcb6078041ae8af4ff147d650d18ea71ac02d759



  #
  # Gemini initializer is being merged into BOTH Vertex and ApiKey authentication.
  #
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
    #################################################################

    #Neha fix
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

  def authenticated?
    # TODO(ricc): add if api_key is valid.. but it should work both ways.
    # OR starts with /^ya29\./
    neha_authenticate unless defined?(@authorizer)
    @authorizer.fetch_access_token!["access_token"].to_s.length == 1024 rescue "NEW_NEHA_authenticate()"
  end

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
