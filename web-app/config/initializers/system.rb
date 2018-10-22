require 'dry/system/rails'

Dry::System::Rails.configure do |config|
  # you can set it to whatever you want and add as many dirs you want
  config.auto_register << 'lib'
end
