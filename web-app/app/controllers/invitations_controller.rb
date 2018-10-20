# frozen_string_literal: true

class InvitationsController < Devise::InvitationsController
  before_action :role_required, except: %i[edit update] # проверяет роль юзера
end
