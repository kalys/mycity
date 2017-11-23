class InvitationsController < Devise::InvitationsController
	before_action :role_required, except: [:edit, :update] # проверяет роль юзера
end