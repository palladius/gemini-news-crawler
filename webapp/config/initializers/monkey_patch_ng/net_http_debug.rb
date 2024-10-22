# # Copied from https://gist.github.com/brainlid/2721486
# # I think we can remove it safely

# require 'net/http'
# module Net
#   class HTTP
#     def self.enable_debug!
#       raise "You don't want to do this in anything but development mode!" unless Rails.env == 'development'
#       class << self
#         alias_method :__new__, :new
#         def new(*args, &blk)
#           instance = __new__(*args, &blk)
#           instance.set_debug_output($stderr)
#           instance
#         end
#       end
#     end

#     def self.disable_debug!
#       class << self
#         alias_method :new, :__new__
#         remove_method :__new__
#       end
#     end
#   end
# end

# # Net::HTTP.enable_debug!
# #Net::HTTP.disable_debug!
