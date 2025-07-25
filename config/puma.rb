# config/puma.rb

# This configuration file will be evaluated by Puma. The top-level methods that
# are invoked here are part of Puma's configuration DSL. For more information
# about methods provided by the DSL, see https://puma.io/puma/Puma/DSL.html.
#
# Puma starts a configurable number of processes (workers) and each process
# serves each request in a thread from an internal thread pool.
#
# You can control the number of workers using ENV["WEB_CONCURRENCY"]. You
# should only set this value when you want to run 2 or more workers. The
# default is already 1.
#
# The ideal number of threads per worker depends both on how much time the
# application spends waiting for IO operations and on how much you wish to
# prioritize throughput over latency.
#
# As a rule of thumb, increasing the number of threads will increase how much
# traffic a given process can handle (throughput), but due to CRuby's
# Global VM Lock (GVL) it has diminishing returns and will degrade the
# response time (latency) of the application.
#
# The default is set to 3 threads as it's deemed a decent compromise between
# throughput and latency for the average Rails application.
#
# Any libraries that use a connection pool or another resource pool should
# be configured to provide at least as many connections as the number of
# threads. This includes Active Record's `pool` parameter in `database.yml`.
threads_count = ENV.fetch("RAILS_MAX_THREADS", 3)
threads threads_count, threads_count

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
port ENV.fetch("PORT", 3000)

# Allow puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart

# Run the Solid Queue supervisor inside of Puma for single-server deployments
plugin :solid_queue if ENV["SOLID_QUEUE_IN_PUMA"]

# Specify the PID file. Defaults to tmp/pids/server.pid in development.
# In other environments, only set the PID file if requested.
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked from the master process after it has loaded the app.
# This makes Puma more resilient to memory leaks and allows for zero-downtime deploys.
# Render automatically sets WEB_CONCURRENCY for you (usually to the CPU count).
workers ENV.fetch("WEB_CONCURRENCY") { 2 } # Common default, adjust if Render suggests otherwise

# Use the `preload_app!` directive to load your application before workers are forked.
# This results in faster worker boot times and reduced memory consumption on platforms
# like Render.
preload_app!

on_worker_boot do
  Rails.logger.info "--- Entering on_worker_boot block ---" # Added for extra clarity
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)

  # Re-configure Cloudinary for each worker process
  if ENV['CLOUDINARY_CLOUD_NAME'].present? && ENV['CLOUDINARY_API_KEY'].present? && ENV['CLOUDINARY_API_SECRET'].present?
    Cloudinary.config do |config|
      config.cloud_name = ENV['CLOUDINARY_CLOUD_NAME']
      config.api_key    = ENV['CLOUDINARY_API_KEY']
      config.api_secret = ENV['CLOUDINARY_API_SECRET']
      config.secure     = true
      config.url        = ENV['CLOUDINARY_URL'] if ENV['CLOUDINARY_URL'].present?
      config.force_canonical_for_private_delivery = true
    end
    Rails.logger.info "Cloudinary re-configured successfully in worker boot. Cloud name: '#{Cloudinary.config.cloud_name}'"
    Rails.logger.info "Worker boot ENV CLOUDINARY_CLOUD_NAME: '#{ENV['CLOUDINARY_CLOUD_NAME']}'"
    Rails.logger.info "Worker boot ENV CLOUDINARY_API_KEY: '#{ENV['CLOUDINARY_API_KEY']}'"
    Rails.logger.info "Worker boot ENV CLOUDINARY_API_SECRET: '#{ENV['CLOUDINARY_API_SECRET']}'"
    Rails.logger.info "Worker boot ENV CLOUDINARY_URL: '#{ENV['CLOUDINARY_URL']}'"
  else
    Rails.logger.warn "WARNING: Cloudinary environment variables are NOT fully set in worker boot."
    Rails.logger.warn "Worker boot ENV CLOUDINARY_CLOUD_NAME: '#{ENV['CLOUDINARY_CLOUD_NAME']}' (present: #{ENV['CLOUDINARY_CLOUD_NAME'].present?})"
    Rails.logger.warn "Worker boot ENV CLOUDINARY_API_KEY: '#{ENV['CLOUDINARY_API_KEY']}' (present: #{ENV['CLOUDINARY_API_KEY'].present?})"
    Rails.logger.warn "Worker boot ENV CLOUDINARY_API_SECRET: '#{ENV['CLOUDINARY_API_SECRET']}' (present: #{ENV['CLOUDINARY_API_SECRET'].present?})"
    Rails.logger.warn "Worker boot ENV CLOUDINARY_URL: '#{ENV['CLOUDINARY_URL']}' (present: #{ENV['CLOUDINARY_URL'].present?})"
  end
  Rails.logger.info "--- Exiting on_worker_boot block ---" # Added for extra clarity
end