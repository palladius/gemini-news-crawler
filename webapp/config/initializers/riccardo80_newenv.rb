#
# RailsCredEnv is better than ENV but:
# * there's two fiels for DEV and PROD (2 files per change - not DRY)
# * in BUILD phase it doesnt seem to able to read it. Maybe this is fixable? Maybe I just need to pass
#   `RAILS_MASTER_KEY` to the build script?
#


RailsCredEnvObj = Rails.application.credentials rescue "Err #{$!}"

RailsCredEnv = Rails.application.credentials['env'] rescue {} # needs to be a hash so it fails nicely later on.

# Playing with ApplCredentials since ENV is SLOW (need to have it in local file, add to CBuild, ..)
# Note that in BUILD phase this seems to be EMPTY. Maybe it doesnt find the ENV[RAILS_MASTER_KEY]?!?
ShowDemoz = Rails.application.credentials['env'].fetch(:SHOW_DEMOZ, false).to_bool rescue false

# Since this seems tow rok well EVERYWHERE except at build time, let me try this:

puts("🤌🤌🤌 RailsCredEnvObj: #{RailsCredEnvObj} 🤌🤌🤌")
puts("🤌🤌🤌 ENV[RAILS_MASTER_KEY].length: #{ENV.fetch('RAILS_MASTER_KEY', '').length} 🤌🤌🤌")
puts("🤌🤌🤌 ENV[_RAILS_MASTER_KEY].length (only in CloudBuild): #{ENV.fetch('_RAILS_MASTER_KEY', '').length} 🤌🤌🤌")
