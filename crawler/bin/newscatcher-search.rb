#!/usr/bin/env ruby

require 'json'
# https://docs.newscatcherapi.com/api-docs/endpoints-1/authentication
# set -euo pipefail

# if [ -f ../_env_gaic.sh ] ; then
#     echo File found.
#     source ../_env_gaic.sh
# fi

# API_KEY="$NEWSCATCHER_API"

# echo "Querying newscatcherapi via API key: '$API_KEY'"
# # My key is v3..
# curl -XGET 'https://v3-api.newscatcherapi.com/api/search?q=Tesla' -H "x-api-token: $API_KEY"
require "uri"
require "net/http"

KEY =  ENV['NEWSCATCHER_API']
SearchString = ARGV.join(' ')
Lang = 'it'
uri = "https://v3-api.newscatcherapi.com/api/search/?q=\"#{SearchString}\"&lang=it,en,en&countries=US,IT,CH" # CA
puts '♦️' * 70
puts("♦️ Riccardo, they key is: #{KEY}")
puts("♦️ Riccardo, they search string is: '#{SearchString}'")
puts '♦️' * 70
puts ''
url = URI(uri)

raise "KEY non datur: mihi date clavem!" if KEY.to_s.empty?
raise "SearchString non datur: mihi date quidam ARGVem!" if SearchString.to_s.empty?


https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true

request = Net::HTTP::Get.new(url)
request["x-api-token"] = KEY

response = https.request(request)
text_response =  response.read_body
puts text_response.class
h = JSON.parse(text_response)
# puts h.class
# puts h.keys
puts("🌎 Total Pages: #{h['total_pages']}")
puts("🌎 Articles found: #{h['articles'].count}")
h['articles'].each_with_index do |a, ix|
    if ix==0
        puts '----'
#        puts a.keys.join(', ')
#        puts a
#        puts '----'
    end
    puts("[#{a['score']}] #{a['published_date']} #{a['domain_url']} '[#{a['language']}] #{a['title']}' 🌏 #{a['link']}" )
    # title, author, authors, journalists, published_date, published_date_precision, updated_date, updated_date_precision, link, domain_url, full_domain_
    #url, name_source, is_headline, paid_content, parent_url, country, rights, rank, media, language, description, content, word_count, is_opinion, twit
    #ter_account, all_links, all_domain_links, id, score
    #    puts a.keys.join(', ')
end
