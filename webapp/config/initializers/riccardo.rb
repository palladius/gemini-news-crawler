

puts "❌ #{ '❌' * 80}"

puts "❌ Welcome to Riccardo Gemini App. To check that DB is fine, let me paste a few DANGEROUS string:"
%w{ DATABASE_URL_DEV DATABASE_URL_PROD RAILS_MASTER_KEY}.each do |env_key|
  puts "❌ ENV[#{env_key}]: #{ ENV.fetch( env_key, '🤷' ).first 5}"
end
puts "❌ Which is why I only show the top 5 chars"

puts "❌ #{ '❌' * 80}"
