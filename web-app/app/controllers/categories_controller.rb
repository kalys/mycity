class CategoriesController < ApplicationController
  before_action :role_required # проверяет роль юзера
  before_action :set_category, only: [:show, :edit, :update, :archiving, :unarchiving]

  def index
    @categories = Category.where(archived: false)
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
  end

  def update
    if @category.update(category_params)
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def show
  end

  def archiving
    @category.archived = true
    @category.save
    redirect_to categories_path
  end

  def unarchiving
    @category.archived = false
    @category.save
    redirect_to categories_path
  end

  def archived_categories
    @categories = Category.where(archived: true)
  end

  private

  def category_params
    params.require(:category).permit(:title)
  end

  def set_category
    @category = Category.find(params[:id])
  end
end
