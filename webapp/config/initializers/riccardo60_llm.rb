# frozen_string_literal: true

##########################
## LLM Constants
#
# I embededed all dev and prod with this!
EmbeddingModel = 'textembedding-gecko-multilingual-NON_VA'
# Alternaives:
# "text-embedding-004" for English.
# "text-multilingual-embedding-002" for i18n.




# Should be Gemini - note this has been renamed from GoogleVertexAI to GoogleVertexAI in 0.13 version
require 'English'
VertexLLM = begin
  Langchain::LLM::GoogleVertexAI.new(project_id: ENV['PROJECT_ID'],
                                     region: 'us-central1')
rescue StandardError
  "VertexLLM Error('#{$ERROR_INFO}')"
end
# VertexLLM.chat messages: 'Ciao come stai?' -> {"error":"invalid_scope","error_description":"Invalid OAuth scope or ID token audience provided."}
gemini_llm_key = begin
  Rails.application.credentials.env.GEMINI_API_KEY_BIG_QUOTA
rescue StandardError
  'nisba'
end
GeminiLLM = begin
  Langchain::LLM::GoogleGemini.new(api_key: gemini_llm_key)
rescue StandardError
  nil
end
# GeminiLLM = Langchain::LLM::GoogleGemini.new api_key: ENV['PALM_API_KEY_GEMINI'] rescue nil

GeminiLLM10 = Langchain::LLM::GoogleGemini.new api_key: ENV['PALM_API_KEY_GEMINI'] , default_options: {chat_completion_model_name: 'gemini-1.0-pro'} # so it doesnt break anything :)

OllamaLLM = begin
  Langchain::LLM::Ollama.new
rescue StandardError
  nil
end

# In order
LLMs = [VertexLLM, GeminiLLM ].freeze

# GeminiAuthenticated = begin
#   GeminiLLM.authenticated?
# rescue StandardError
#   "Error: #{$ERROR_INFO}"
# end
GeminiApiKeyLength = begin
  GeminiLLM.api_key.to_s.length
rescue StandardError
  (-1)
end

# # This code is created by ricc patching manually langchain...
# GeminiLLMAuthenticated = begin
#   GeminiLLM.authenticated?
# rescue StandardError
#   "UnImplemented - Probably Derek Only but things are moving since v0.3.23. Error: #{$ERROR_INFO}"
# end


# VertexAuthenticated = !begin
#   VertexLLM.authorizer.fetch_access_token
# rescue StandardError
#   false
# end.nil?

VertexAuthTokenLength = begin
  VertexLLM.authorizer.fetch_access_token['access_token'].to_s.length
rescue StandardError
  (-1)
end
# This doesnt make sense: only works if its already authenticated
# VertexAuthenticatedAlready = !!(VertexLLM.authorizer.refresh_token.to_s.match?(/^1\/\//) rescue false) # Vertex auth is ok

BookOfLLMs = {
  vertex: {
    llm: VertexLLM.class,
    description: 'This is the only HIGH QPS I have but unfortunately I seem to be able to only use it for embeddings. which is great, since theyre the only thing i do at big scale. But then it breaks my demo if I ask more than 5 request per minute (5QPM)',
    auth_method: 'GCP (high QPS)'
    # authenticated1: VertexAuthenticated,
    # authenticated2: VertexLLMAuthenticated,
  },
  gemini: {
    llm: GeminiLLM.class,
    description: 'todo',
    auth_method: 'api_key (low QPS)',
    #authenticated1: GeminiAuthenticated, # <== this gives an error
  },
  ollama: {
    llm: OllamaLLM.class,
    description: 'not used ANYWHERE for now'
    # auth_method: 'api_key (low QPS)',
  }
}.freeze
