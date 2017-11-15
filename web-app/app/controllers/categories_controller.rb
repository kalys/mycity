<<<<<<< HEAD
class CategoriesController < ApplicationController
=======
class CategoriesController < ApplicationController  
  before_action :role_required # проверяет роль юзера
  
>>>>>>> 34eb92328764bbc1fd35a4cc4a0f74fca594b334
  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def destroy
    @category = Category.destroy(params[:id])
    redirect_to root_path
  end

  def show
    @category = Category.find(params[:id])
  end

  private

  def category_params
    params.require(:category).permit(:title)
  end
end
