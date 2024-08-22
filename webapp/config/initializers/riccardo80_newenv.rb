# frozen_string_literal: true

#
# RailsCredEnv is better than ENV but:
# * there's two fiels for DEV and PROD (2 files per change - not DRY)
# * in BUILD phase it doesnt seem to able to read it. Maybe this is fixable? Maybe I just need to pass
#   `RAILS_MASTER_KEY` to the build script?
#

require 'English'
RailsCredEnvObj = begin
  Rails.application.credentials
rescue StandardError
  "Err #{$ERROR_INFO}"
end

RailsCredEnv = begin
  Rails.application.credentials['env']
rescue StandardError
  {}
end

# Playing with ApplCredentials since ENV is SLOW (need to have it in local file, add to CBuild, ..)
# Note that in BUILD phase this seems to be EMPTY. Maybe it doesnt find the ENV[RAILS_MASTER_KEY]?!?
ShowDemoz = begin
  Rails.application.credentials['env'].fetch(:SHOW_DEMOZ, false).to_bool
rescue StandardError
  false
end

# Since this seems tow rok well EVERYWHERE except at build time, let me try this:

puts("🤌🤌🤌 RailsCredEnvObj: #{RailsCredEnvObj} 🤌🤌🤌")
puts("🤌🤌🤌 ENV[RAILS_MASTER_KEY].length: #{ENV.fetch('RAILS_MASTER_KEY', '').length} 🤌🤌🤌")

# I dont think its ever used.
#puts("🤌🤌🤌 ENV[_RAILS_MASTER_KEY].length (only in CloudBuild): #{ENV.fetch('_RAILS_MASTER_KEY', '').length} 🤌🤌🤌")
