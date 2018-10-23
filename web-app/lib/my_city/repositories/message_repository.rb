module MyCity
  module Repositories
    class MessageRepository
      attr_reader :relation

      def initialize(relation = Message.unscoped)
        @relation = relation
      end

      def create(message)
        relation.create(message.attributes).tap do |persisted_message|
          message.built_images.each do |image|
            image.message = persisted_message
            image.save!
          end
        end
      end
    end
  end
end
