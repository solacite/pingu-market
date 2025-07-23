Rails.logger.debug "DEBUG: Cloudinary initializer is being loaded."

Cloudinary.config do |config|
  config.cloud_name = ENV['CLOUDINARY_CLOUD_NAME']
  config.api_key    = ENV['CLOUDINARY_API_KEY']
  config.api_secret = ENV['CLOUDINARY_API_SECRET']
  config.secure     = true
end

Rails.logger.debug "DEBUG: Cloudinary config after initializer: #{Cloudinary.config.cloud_name.present? ? 'Cloud name present' : 'Cloud name MISSING!'}"