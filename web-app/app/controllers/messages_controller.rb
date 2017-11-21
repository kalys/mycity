class MessagesController < ApplicationController
  before_action :role_required, except: [:create]  # проверяет роль юзера
  skip_before_action :authenticate_user!, only: [:create]

  def index
    @messages = Message.all
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.create(message_params)
    @message.images.create(image_params)
  end

  def done
    @message = Message.find(params[:id])
    @message.update({status: "Done"})

    redirect_back(fallback_location: root_path)
  end

  def actual
    @message = Message.find(params[:id])
    @message.update({status: "Actual"})

    redirect_back(fallback_location: root_path)
  end

  def hidden
    @message = Message.find(params[:id])
    @message.update({status: "Hidden"})

    redirect_back(fallback_location: root_path)
  end

  def not_relevant
    @message = Message.find(params[:id])
    @message.update({status: "Not relevant"})

    redirect_back(fallback_location: root_path)
  end

  def show
    @message = Message.find(params[:id])
  end

  def edit
    @message = Message.find(params[:id])
  end

  def update
    @message = Message.find(params[:id])
    if @message.update(message_params)
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private
  def message_params
    params.require(:message).permit(:body, :latitude, :longitude, :address, :status, :category_id)
  end

  def image_params
    params.require(:image).permit(:image)
  end
end
