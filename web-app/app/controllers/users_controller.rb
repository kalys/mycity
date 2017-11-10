class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def edit
  	@user = User.find(params[:id])
  end

  def index
  	@users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  		redirect_to root_path
  		flash[:success] = "User successfuly created."
  	else
  		render "new"
  		flash[:danger] = "Error."
  	end
  end

  def update
  	@user = User.find(params[:id])
  	if @user.update(user_params)
  		redirect_to root_path
  		flash[:success] = "User successfuly updated"
  	else
  		render "edit"
  		flash[:danger] = "Error."
  	end
  end

  def destroy
  	@user = User.find(params[:id])
  	@user.destroy

  	redirect_to root_path
  end

  private

  def user_params
  	params.require(:user).permit(:name, :email, :password)
  end
end
