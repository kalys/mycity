class MessagesController < ApplicationController
before_action :authenticate_user!, except: [:index, :show]
  def index
    @messages = Message.all
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    if @message.save
      redirect_to root_path
    else
      render 'new'
    end
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
    params.require(:message).permit(:body, :latitude, :longitude, :address, :status, :category_id, :image_id)
  end
end
