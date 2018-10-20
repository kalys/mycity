# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module WebApp
  class Application < Rails::Application
    config.load_defaults 5.1
    config.i18n.default_locale = :en
    config.filter_parameters << :password
  end
end
