puts "DEBUG: === application.rb file started loading ==="

require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Store
  puts "DEBUG: === Inside Store module, before Application class ==="

  class Application < Rails::Application
    puts "DEBUG: === Inside Application class definition ==="

    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
      if ENV['CLOUDINARY_CLOUD_NAME'].present?
    Cloudinary.config do |config|
      config.cloud_name = ENV['CLOUDINARY_CLOUD_NAME']
      config.api_key    = ENV['CLOUDINARY_API_KEY']
      config.api_secret = ENV['CLOUDINARY_API_SECRET']
      config.secure     = true
      config.url        = ENV['CLOUDINARY_URL'] if ENV['CLOUDINARY_URL'].present?
    end
    Rails.logger.debug "DEBUG: Cloudinary configured in application.rb"
    Rails.logger.debug "DEBUG: Cloudinary.config.cloud_name from application.rb: '#{Cloudinary.config.cloud_name}'"
  else
    Rails.logger.debug "DEBUG: CLOUDINARY_CLOUD_NAME NOT PRESENT IN APPLICATION.RB STARTUP"
  end
  end
end
