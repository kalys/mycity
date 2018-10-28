require 'import'

module MyCity
  module Repositories
    class MessageRepository
      include WebApp::Import[
        'relations.messages.relation',
        'my_city.repositories.image_repository'
      ]

      def create(message)
        relation.create(message.attributes).tap do |persisted_message|
          message.built_images.each do |image|
            image.message = persisted_message
            image_repository.save(image)
          end
        end
      end

      def transaction
        relation.transaction do
          yield
        end
      end

      def rollback_exception
        ActiveRecord::Rollback
      end
    end
  end
end
