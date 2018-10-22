# frozen_string_literal: true

WebApp::Container.boot(:telegram) do |container|
  use :logger

  init do
    require 'telegram/bot'
  end

  start do
    bot = Telegram::Bot::Client.new(ENV['BOT_TOKEN'], logger: logger)
    container.register('telegram.bot', bot)
  end
end
