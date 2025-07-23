Cloudinary.config do |config|
  config.cloud_name = ENV['CLOUDINARY_CLOUD_NAME']
  config.api_key    = ENV['CLOUDINARY_API_KEY']
  config.api_secret = ENV['CLOUDINARY_API_SECRET']
  # config.secure     = true # Often useful to force HTTPS URLs
  # config.cdn_subdomain = true # If you want to use cdn.example.com for images
end