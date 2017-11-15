class InvitationsController < Devise::InvitationsController
  before_action :role_required, except: :edit # проверяет роль юзера
end