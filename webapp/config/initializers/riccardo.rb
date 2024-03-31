
APP_NAME = ENV.fetch 'APP_NAME', 'GemiNews'
APP_VERSION = `cat ./VERSION`.chomp rescue "ERROR: #{$!}"



######### Ciao da Riccardo
emoji = '🧡'
puts "#{emoji} #{ emoji * 80}"

puts "#{emoji} Welcome to #{APP_NAME} v#{APP_VERSION}"
puts "#{emoji} To check that DB is fine, let me paste a few DANGEROUS string:"
# Secret stuff
%w{ DATABASE_URL_DEV DATABASE_URL_PROD RAILS_MASTER_KEY NEWSAPI_COM_KEY}.each do |env_key|
  puts "#{emoji} 🕵️‍♂️ ENV[#{env_key}]: #{ ENV.fetch( env_key, '🤷' ).first 5}"
end
puts "#{emoji} Which is why I only show the top 5 chars"
# Public stuff
%w{ APP_NAME SKAFFOLD_DEFAULT_REPO}.each do |env_key|
  puts "#{emoji} ☀️ ENV[#{env_key}]: #{ ENV.fetch( env_key, '🤷' )}"
end
puts "#{emoji} #{ emoji * 80}"
