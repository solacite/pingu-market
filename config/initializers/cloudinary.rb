if ENV['CLOUDINARY_CLOUD_NAME'].present? && ENV['CLOUDINARY_API_KEY'].present? && ENV['CLOUDINARY_API_SECRET'].present?
  Cloudinary.config do |config|
    config.cloud_name = ENV['CLOUDINARY_CLOUD_NAME']
    config.api_key    = ENV['CLOUDINARY_API_KEY']
    config.api_secret = ENV['CLOUDINARY_API_SECRET']
    config.secure     = true
    config.url        = ENV['CLOUDINARY_URL'] if ENV['CLOUDINARY_URL'].present?
  end
  Rails.logger.info "Cloudinary configured successfully from initializer."
  Rails.logger.info "Cloudinary.config.cloud_name: '#{Cloudinary.config.cloud_name}'"
  Rails.logger.info "Cloudinary.config.api_key present: #{Cloudinary.config.api_key.present?}"
else
  Rails.logger.warn "WARNING: Cloudinary environment variables are not fully set in initializer. Check CLOUDINARY_CLOUD_NAME, CLOUDINARY_API_KEY, CLOUDINARY_API_SECRET, CLOUDINARY_URL."
  Rails.logger.warn "CLOUDINARY_CLOUD_NAME: '#{ENV['CLOUDINARY_CLOUD_NAME']}'"
  Rails.logger.warn "CLOUDINARY_API_KEY: '#{ENV['CLOUDINARY_API_KEY']}'"
end