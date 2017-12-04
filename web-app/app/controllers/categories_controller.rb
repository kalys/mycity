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
      flash[:success] = "Category successfully created."
    else
      render 'new'
      flash[:danger] = "Error."
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to root_path
      flash[:success] = "Category successfully updated."
    else
      render 'edit'
      flash[:danger] = "Error."
    end
  end

  def show
  end

  def archiving
    @category.archived = true
    @category.save
    flash[:success] = "Category successfully archived."
    redirect_to categories_path
  end

  def unarchiving
    @category.archived = false
    @category.save
    flash[:success] = "Category successfully unarchived."
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
