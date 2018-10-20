# frozen_string_literal: true

Rails.application.configure do
  config.cache_classes = true

  config.eager_load = false

  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.seconds.to_i}"
  }

  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.action_dispatch.show_exceptions = false

  config.action_controller.allow_forgery_protection = false

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = { host: 'localhost', port: 31_337 }
  config.action_mailer.smtp_settings = { address: 'localhost', port: 1025 }
  config.action_mailer.perform_caching = false

  config.active_support.deprecation = :stderr
end
