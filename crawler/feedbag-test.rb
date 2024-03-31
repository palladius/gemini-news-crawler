#!/usr/bin/env ruby

#require 'feedjira'
#require 'httparty'
require 'feedbag'
require_relative './constants.rb'
require 'colorize'


def main
  puts "Hello World!"
  p NewsFeedback
  NewsFeedback.each do |topic, urls|
    puts('Topic: #{topic}')
    urls.each do |url|
      feedbag = Feedbag.find(url,
        'User-Agent' => "Riccardo Personal Agent/1.0.1",
        read_timeout: 2,
        open_timeout: 2, #openuri - seconds https://rubyapi.org/o/openuri/openread#method-i-open
      )
      puts "🗺️ #{url} -> #{feedbag.to_s.colorize :yellow}"
    end
  end
end

# This block ensures that the `main` method is only called when the script is run directly
if __FILE__ == $PROGRAM_NAME
  main
end
