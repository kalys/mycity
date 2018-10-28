require 'dry/system/rails'

Dry::System::Rails.configure do |config|
  # you can set it to whatever you want and add as many dirs you want
  config.auto_register << 'lib'
end

Rails.application.config.after_initialize do
  WebApp::Container.register('relations.messages.relation', Message.unscoped)
  WebApp::Container.register('relations.images.relation', Image.unscoped)
end
