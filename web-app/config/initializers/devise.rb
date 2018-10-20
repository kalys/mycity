# frozen_string_literal: true

Devise.setup do |config|
  config.mailer_sender = 'no-reply@my-city.com'
  config.secret_key = '9b5fa0bee984d99671555449f459684f8c0e431037c208e548ff138d6340c5cbb9232d27d1c5186e96d3c76cb1b36ba20ede01570a6f8485ecfdb76ccaee9754'

  require 'devise/orm/active_record'

  config.case_insensitive_keys = [:email]

  config.strip_whitespace_keys = [:email]

  config.skip_session_storage = [:http_auth]

  config.stretches = Rails.env.test? ? 1 : 11

  config.reconfirmable = true

  config.expire_all_remember_me_on_sign_out = true

  config.password_length = 6..128

  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  config.reset_password_within = 6.hours

  config.sign_out_via = :get
end
