
APP_NAME = ENV.fetch 'APP_NAME', 'GemiNews'
EmojiAppName = "♊️ GemiNews 🗞️"
APP_VERSION = `cat ./VERSION`.chomp rescue "ERROR: #{$!}"
ENABLE_GCP = (ENV['ENABLE_GCP'].to_s.downcase == 'true')
# Note this is NOT necessary to run GCP, its just ONE way.
GAC = ENV.fetch 'GOOGLE_APPLICATION_CREDENTIALS', nil
GOOGLE_APPLICATION_CREDENTIALS  = ENV.fetch 'GOOGLE_APPLICATION_CREDENTIALS', nil
EmbeddingEmoji = '🗿'

def gcp?()
  ENABLE_GCP
end

GCP_KEY_PATH =  gcp? ? ENV['GCP_KEY_PATH_FROM_WEBAPP'] : nil
GCP_KEY_PATH_EXISTS = File.exist?(GCP_KEY_PATH) rescue false
# https://console.cloud.google.com/run/deploy/europe-west1/gemini-news-crawler-dev?project=palladius-genai
CLOUDRUN_SA_KEY_EXISTS = File.exist?('/geminews-key/geminews-key') # rescue false
CLOUDRUN_ENVRC_EXISTS = File.exist?('/secretenvrc/gemini-news-crawler-envrc') # rescue false

RailsCredEnv = Rails.application.credentials['env'] rescue {} #['BUCKET_NAME']

# Should be Gemini - note this has been renamed from GoogleVertexAI to GoogleVertexAI in 0.13 version
VertexLLM = Langchain::LLM::GoogleVertexAI.new(project_id: ENV['PROJECT_ID'], region: 'us-central1') rescue "VertexLLM Error('#{$!}')"
# VertexLLM.chat messages: 'Ciao come stai?' -> {"error":"invalid_scope","error_description":"Invalid OAuth scope or ID token audience provided."}
GeminiLLM = Langchain::LLM::GoogleGemini.new api_key: ENV['PALM_API_KEY_GEMINI'] rescue nil
OllamaLLM = Langchain::LLM::Ollama.new rescue nil


GeminiAuthenticated = false # doesnt work GeminiLLM.authorizer.refresh_token.match? /^1\/\// # Vertex auth is ok
GeminiApiKeyLength = GeminiLLM.api_key.to_s.length rescue (-1)

# This code is created by ricc patching manually langchain...
GeminiLLMAuthenticated = GeminiLLM.authenticated? rescue "UnImplemented - Probably Derek Only but things are moving since v0.3.23. Error: #{$!}"
VertexLLMAuthenticated = VertexLLM.authenticated? rescue "UnImplemented - Probably Derek Only but things are moving since v0.3.23. Error: #{$!}"


VertexAuthenticated = !!(VertexLLM.authorizer.fetch_access_token rescue false)
VertexAuthTokenLength = VertexLLM.authorizer.fetch_access_token['access_token'].to_s.length rescue (-1)  # => 1024
# This doesnt make sense: only works if its already authenticated
# VertexAuthenticatedAlready = !!(VertexLLM.authorizer.refresh_token.to_s.match?(/^1\/\//) rescue false) # Vertex auth is ok

# Old
NewsRetrieverENV = Langchain::Tool::NewsRetriever.new(api_key: ENV["NEWS_API_KEY"])
# in cloud Build I get this error:
# NewsRetriever = Langchain::Tool::NewsRetriever.new(api_key: Rails.application.credentials.env.NEWSAPI_COM_KEY )
# NoMethodError: undefined method `NEWSAPI_COM_KEY' for nil:NilClass (NoMethodError)
NewsRetriever = Langchain::Tool::NewsRetriever.new(api_key: (Rails.application.credentials.env.fetch(:NEWSAPI_COM_KEY, nil) rescue "error #{$!}") )

Rails.application.configure do

  config.hosts << "gemini-news-crawler-dev-x42ijqglgq-ew.a.run.app"
  config.hosts << "gemini-news-crawler-manhouse-dev-x42ijqglgq-ew.a.run.app"
  config.hosts << "gemini-news-crawler-dev-x42ijqglgq-ew.a.run.app"    # Allow requests from example.com
  config.hosts << /gemini-news-crawler.*\.run\.app/
  config.hosts << "localhost:3000"
  config.hosts << "localhost"
  config.hosts << "localhost:3001"
  config.hosts << "localhost:8080"
  # Skip DNS rebinding protection for the default health check endpoint.
  #config.host_authorization = { exclude: ->(request) { request.path == "/up" } }
  #config.host_authorization = { exclude: ->(request) { request.path == "/statusz" } }

  # Disable AR logging for super long thingy: https://stackoverflow.com/questions/13051949/how-to-disable-activerecord-logging-for-a-certain-column
  config.filter_parameters << :title_embedding
  config.filter_parameters << :article_embedding
  config.filter_parameters << :summary_embedding

end



######## Ricc Header
######### Ciao da Riccardo
emoji = '🧡'
# 🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡
puts "#{emoji} #{ emoji * 60}"

puts "#{emoji} Welcome to #{APP_NAME} v#{APP_VERSION}"
puts "#{emoji} To check that DB is fine, let me paste a few 🕵️‍♂️ SECRET things:"
# Secret stuff
%w{ DATABASE_URL_DEV DATABASE_URL_PROD RAILS_MASTER_KEY NEWSAPI_COM_KEY GEMINI_KEY GCP_KEY_PATH}.sort.each do |env_key|
  puts "#{emoji} 🕵️‍♂️ ENV[#{env_key}]: #{ ENV.fetch( env_key, '🤷' ).first 5}... (size: #{ENV.fetch( env_key, '🤷' ).size})"
end
puts "#{emoji} .. which is why I only show the top N chars. Note that Gemini and NewsAPI keys are useless so far.."
# Public stuff
puts "#{emoji}"
puts "#{emoji} And now the 🌞 PUBLIC stuff:"
puts "#{emoji} 🌞 Rails.env: #{Rails.env}"
%w{ APP_NAME SKAFFOLD_DEFAULT_REPO ENABLE_GCP MESSAGGIO_OCCASIONALE RAILS_ENV GCP_KEY_PATH_FROM_WEBAPP}.sort.each do |env_key|
  puts "#{emoji} 🌞 ENV[#{env_key}]: #{ ENV.fetch( env_key, '🤷' )}"
end
# Now normal variables..
puts "#{emoji} 🌞 GCP_KEY_PATH:           #{GCP_KEY_PATH}"
puts "#{emoji} 🌞 GCP_KEY_PATH_EXISTS:    #{GCP_KEY_PATH_EXISTS}"
puts "#{emoji} 🌞 CLOUDRUN_SA_KEY_EXISTS: #{CLOUDRUN_SA_KEY_EXISTS}" # should only exist in ricc cloud run. For debug
puts "#{emoji} 🌞 CLOUDRUN_ENVRC_EXISTS:  #{CLOUDRUN_ENVRC_EXISTS}"
puts "#{emoji} 🌞 GOOGLE_APPLICATION_CREDENTIALS:  #{GOOGLE_APPLICATION_CREDENTIALS}"
puts "#{emoji} 🪄 Vertex (old GeminiLLM): #{VertexLLM}"
puts "#{emoji} 🪄 VertexAuthenticated:    #{VertexAuthenticated}"
puts "#{emoji} 🪄 VertexAuthTokenLength:  #{VertexAuthTokenLength}"
puts "#{emoji} ♊ GeminiLLM (new v13):    #{GeminiLLM}"
puts "#{emoji} ♊ GeminiAuthen'd (TODO):  #{GeminiAuthenticated}"
puts "#{emoji} ♊ GeminiApiKeyLength:     #{GeminiApiKeyLength}"



puts "#{emoji} #{ emoji * 60}"


if gcp?
  # if not, we're cool.
  if GCP_KEY_PATH_EXISTS
    puts "All good, GCP Key exists"
  else
    # if I do a raise here - it doesnt even compile. This needs to work at RUNTIME not at every bloody rake command.
    puts "[WARNING] I need GCP_KEY_PATH to exist - Otherwise set ENABLE_GCP to false! Maybe a problem in the dockerization? ;) GCP_KEY_PATH=#{GCP_KEY_PATH}"
  end
end