CarrierWave.configure do |config|
  if Rails.env.development? || Rails.env.test?
    config.storage    = :file
  elsif Rails.env.production?
    config.storage    = :aws
    config.aws_bucket = 'mycity-dev'
    config.aws_acl    = 'public-read'

    config.aws_credentials = {
        access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
        secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
        region: ENV.fetch('AWS_REGION') # Required
    }
  end
end