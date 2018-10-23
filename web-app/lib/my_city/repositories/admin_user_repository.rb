module MyCity
  module Repositories
    class AdminUserRepository
      attr_reader :relation

      def initialize(relation = AdminUser.unscoped)
        @relation = relation
      end

      def telegram_moderators
        relation.where("telegram_login is NOT NULL")
      end
    end
  end
end
