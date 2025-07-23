# config/initializers/cloudinary.rb

Rails.logger.debug "DEBUG: Cloudinary initializer is being loaded."

Cloudinary.config do |config|
  config.cloud_name = ENV['CLOUDINARY_CLOUD_NAME']
  config.api_key    = ENV['CLOUDINARY_API_KEY']
  config.api_secret = ENV['CLOUDINARY_API_SECRET']
  config.secure     = true
  # This line is often helpful if CLOUDINARY_URL isn't explicitly setting it
  config.url        = ENV['CLOUDINARY_URL'] if ENV['CLOUDINARY_URL'].present?
end

Rails.logger.debug "DEBUG: Cloudinary config after initializer: Cloud name present? #{Cloudinary.config.cloud_name.present?}, API Key present? #{Cloudinary.config.api_key.present?}, API Secret present? #{Cloudinary.config.api_secret.present?}"