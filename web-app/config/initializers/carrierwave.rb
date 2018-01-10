CarrierWave.configure do |config|
  if Rails.env.development? || Rails.env.test?
    config.storage    = :file
  elsif Rails.env.production?
    config.storage    = :aws
    config.aws_bucket = 'mycity-dev'
    config.aws_acl    = 'public-read'

    config.aws_credentials = {
      access_key_id:     'AKIAIESPOT5EFK2JRASA',
      secret_access_key: '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',
      region:            'eu-central-1'
    }
  end
end