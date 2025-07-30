require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot for better performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Disable serving static files since this is an API-only application.
  config.public_file_server.enabled = false

  # Include generic and useful information about system operation.
  config.log_level = :info

  # Prepend all log lines with request ID.
  config.log_tags = [ :request_id ]

  # Use default logging formatter.
  config.log_formatter = ::Logger::Formatter.new

  # Log to STDOUT for deployment platforms.
  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveLogger::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Enable locale fallbacks for I18n.
  config.i18n.fallbacks = true

  # Session configuration for cross-origin requests
  config.session_store :cookie_store, 
    key: '_mysmsback_session',
    domain: :all,
    same_site: :none,
    secure: true

  # CORS configuration for production - TEMPORARILY ALLOW ALL ORIGINS FOR DEBUGGING
  frontend_url = 'https://my-sms-front.vercel.app'
  
  config.after_initialize do
    Rails.logger.info "CORS Configuration - FRONTEND_URL: #{ENV['FRONTEND_URL']}"
    Rails.logger.info "CORS Configuration - Using origins: #{frontend_url}"
    Rails.logger.info "CORS Configuration - TEMPORARILY ALLOWING ALL ORIGINS"
  end
  
  config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*'  # Temporarily allow all origins for debugging
      resource '*',
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head],
        credentials: false  # Temporarily disable credentials for debugging
    end
  end
end
