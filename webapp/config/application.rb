require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Webapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks tools))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # My stuff
    #config.autoload_paths << Rails.root.join('lib')
    #config.eager_load_paths << Rails.root.join('lib')
    #config.autoload_lib(ignore: %w[tasks assets])

    # This doesn't work in PROD: https://stackoverflow.com/questions/60814100/uninitialized-constant-error-when-switching-to-zeitwerk
    # Dir[Rails.root + 'lib/monkey_patching/*.rb'].each {|file| require file rescue nil } rescue nil

  end
end
