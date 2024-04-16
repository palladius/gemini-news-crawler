
APP_NAME = ENV.fetch 'APP_NAME', 'GemiNews'
EmojiAppName = "♊️ GemiNews 🗞️"
APP_VERSION = `cat ./VERSION`.chomp rescue "ERROR: #{$!}"
ENABLE_GCP = (ENV['ENABLE_GCP'].to_s.downcase == 'true')
EmbeddingEmoji = '🗿'

def gcp?()
  ENABLE_GCP
end

GCP_KEY_PATH =  gcp? ? ("../" + ENV['GCP_KEY_PATH']) : nil
GCP_KEY_PATH_EXISTS = File.exist?(GCP_KEY_PATH)

RailsCredEnv = Rails.application.credentials['env'] rescue {} #['BUCKET_NAME']

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
%w{ APP_NAME SKAFFOLD_DEFAULT_REPO ENABLE_GCP MESSAGGIO_OCCASIONALE RAILS_ENV}.sort.each do |env_key|
  puts "#{emoji} 🌞 ENV[#{env_key}]: #{ ENV.fetch( env_key, '🤷' )}"
end
# Now normal variables..
puts "#{emoji} 🌞 GCP_KEY_PATH_EXISTS:  #{ GCP_KEY_PATH_EXISTS}"
puts "#{emoji} #{ emoji * 60}"


if gcp?
  # if not, we're cool.
  if GCP_KEY_PATH_EXISTS
    puts "All good, GCP Key exists"
  else
    raise "I need GCP_KEY_PATH to exist! Maybe a problem in the dockerization? ;) GCP_KEY_PATH=#{GCP_KEY_PATH}"
  end
end
