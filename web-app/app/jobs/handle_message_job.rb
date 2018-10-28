# frozen_string_literal: true

require 'import'

class HandleMessageJob < ApplicationJob
  include WebApp::Import[
    'logger',
    'my_city.transactions.create_message_transaction'
  ]
  queue_as :default

  def perform(items_json)
    items = JSON.parse(items_json)
    Raven.extra_context(items: items)
    logger.info("New message items: #{items.to_json}")

    create_message_transaction.call(items) do |m|
      m.success do |message|
        m.info("Message created")
      end

      m.failure do |error|
        logger.error(error)
      end
    end
  end
end
