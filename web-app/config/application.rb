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
  config.dsn = 'https://880b31936a6b4bbcafed5443d5cd906d:5dbab763de0a43c1b134b3cff620cd26@sentry.io/276188'
end
