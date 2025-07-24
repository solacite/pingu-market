if ENV['CLOUDINARY_CLOUD_NAME'].present? && ENV['CLOUDINARY_API_KEY'].present? && ENV['CLOUDINARY_API_SECRET'].present?
  
  Rails.logger.info "Cloudinary raw ENV['CLOUDINARY_URL']: '#{ENV['CLOUDINARY_URL']}'"

  Cloudinary.config do |config|
    config.cloud_name = ENV['CLOUDINARY_CLOUD_NAME']
    config.api_key    = ENV['CLOUDINARY_API_KEY']
    config.api_secret = ENV['CLOUDINARY_API_SECRET']
    config.secure     = true
    config.url        = ENV['CLOUDINARY_URL'] if ENV['CLOUDINARY_URL'].present?

    config.force_canonical_for_private_delivery = true 
  end

  Rails.logger.info "Cloudinary configured successfully from initializer."
  Rails.logger.info "Cloudinary.config.cloud_name: '#{Cloudinary.config.cloud_name}'"
  Rails.logger.info "Cloudinary.config.api_key present: #{Cloudinary.config.api_key.present?}"
  Rails.logger.info "Cloudinary.config.secure: #{Cloudinary.config.secure}"
  Rails.logger.info "Cloudinary.config.url: '#{Cloudinary.config.url}'" 
else
  Rails.logger.warn "WARNING: Cloudinary environment variables are not fully set in initializer. Check CLOUDINARY_CLOUD_NAME, CLOUDINARY_API_KEY, CLOUDINARY_API_SECRET, CLOUDINARY_URL."
  Rails.logger.warn "CLOUDINARY_CLOUD_NAME: '#{ENV['CLOUDINARY_CLOUD_NAME']}'"
  Rails.logger.warn "CLOUDINARY_API_KEY: '#{ENV['CLOUDINARY_API_KEY']}'"
end