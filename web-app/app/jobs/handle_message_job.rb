class HandleMessageJob < ApplicationJob
  queue_as :default

  def perform(key, items_json)
    Rails.logger.info key
    Rails.logger.info JSON.parse(items_json)
  end
end
