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

#
# This is needed otherwise in cloud run I ghet this error:
# UnImplemented - Probably Derek Only but things are moving since v0.3.23. Error: undefined method `authenticated?'
# for "VertexLLM Error('undefined method `project_id' for #<Google::Auth::GCECredentials:0x00003e55f787dc10
#   @universe_domain_overridden=false, @authorization_uri=nil, @token_credential_uri=nil, @client_id=nil, @client_secret=nil,
#   @code=nil, @expires_at=nil, @issued_at=nil, @issuer=nil, @password=nil, @principal=nil, @redirect_uri=nil,
#   @scope=[\"https://www.googleapis.com/auth/cloud-platform\", \"https://www.googleapis.com/auth/generative-language.retriever\"],
#   @target_audience=nil, @state=nil, @username=nil, @access_type=:offline, @granted_scopes=nil, @expiry=60,
#   @extension_parameters={}, @additional_parameters={}>')":String
#
#
class Google::Auth::GCECredentials
  # monkeypatched AF, I know!
  def project_id
    default_project_id = 'palladius-genai' # TODO move to ENV[] ma lo posso testare solo a manhouse..
    ENV.fetch 'PROJECT_ID', default_project_id
  end

end
