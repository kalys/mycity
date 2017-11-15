class InvitationsController < Devise::InvitationsController
  before_action :role_required # проверяет роль юзера
end