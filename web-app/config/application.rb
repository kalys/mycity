require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module WebApp
  class Application < Rails::Application

    config.load_defaults 5.1
    config.i18n.default_locale = :ru
    config.filter_parameters << :password
  end
end

Raven.configure do |config|
  config.dsn = 'https://9876e84c8c794f3abf626f72177cefd8:0b286452fad24e43a86bea419a62d5fd@sentry.io/290632'
end
