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

    Cloudinary.config do |cloudinary_config|
      puts "DEBUG: === Inside Cloudinary.config block ==="
      cloudinary_config.cloud_name = ENV['CLOUDINARY_CLOUD_NAME']
      cloudinary_config.api_key    = ENV['CLOUDINARY_API_KEY']
      cloudinary_config.api_secret = ENV['CLOUDINARY_API_SECRET']
      cloudinary_config.secure     = true
      cloudinary_config.url        = ENV['CLOUDINARY_URL'] if ENV['CLOUDINARY_URL'].present?
    end
    puts "DEBUG: === After Cloudinary.config block ==="


    config.after_initialize do
      puts "DEBUG: === Inside config.after_initialize block ==="
      Rails.logger.debug "DEBUG: Application.rb after_initialize hook running."
      Rails.logger.debug "DEBUG: ENV['CLOUDINARY_CLOUD_NAME'] = #{ENV['CLOUDINARY_CLOUD_NAME'].present? ? 'PRESENT' : 'MISSING'}"
      Rails.logger.debug "DEBUG: ENV['CLOUDINARY_API_KEY'] = #{ENV['CLOUDINARY_API_KEY'].present? ? 'PRESENT' : 'MISSING'}"
      Rails.logger.debug "DEBUG: ENV['CLOUDINARY_API_SECRET'] = #{ENV['CLOUDINARY_API_SECRET'].present? ? 'PRESENT' : 'MISSING'}"
      Rails.logger.debug "DEBUG: ENV['CLOUDINARY_URL'] = #{ENV['CLOUDINARY_URL'].present? ? 'PRESENT' : 'MISSING'}"
      Rails.logger.debug "DEBUG: Cloudinary.config.cloud_name = #{Cloudinary.config.cloud_name.present? ? 'PRESENT' : 'MISSING'}"
      Rails.logger.debug "DEBUG: Cloudinary.config.api_key = #{Cloudinary.config.api_key.present? ? 'PRESENT' : 'MISSING'}"
      Rails.logger.debug "DEBUG: Cloudinary.config.api_secret = #{Cloudinary.config.api_secret.present? ? 'PRESENT' : 'MISSING'}"
      puts "DEBUG: === After all debug checks in after_initialize ===" # ADD THIS
    end

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
