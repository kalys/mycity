# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :role_required # проверяет роль юзера

  def index
    @users = User.all
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :role_id)
  end
end
