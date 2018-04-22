Raven.configure do |config|
  if Rails.env.production? or Rails.env.staging?
    config.dsn = 'https://9876e84c8c794f3abf626f72177cefd8:0b286452fad24e43a86bea419a62d5fd@sentry.io/290632'
  end
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
end
