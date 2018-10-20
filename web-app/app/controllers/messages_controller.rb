# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :set_message, only: %i[update show edit archiving]

  def index
    @messages = Message.where(status: :actual)
  end

  def index_old
    if params[:status].nil?
      @messages = Message.all.where.not(status: :hidden).order(created_at: :desc).order(:body).page(params[:page])
      @title = 'Все сообщения'
    else
      @messages = Message.all.where(status: params[:status]).order(created_at: :desc).order(:body).page(params[:page])
      @title =
        case params[:status]
        when 'new_message'
          'Новые сообщения'
        when 'done'
          'Выполненные сообщения'
        when 'actual'
          'Актуальные сообщения'
        when 'not_relevant'
          'Неактуальные сообщения'
        end
    end
  end

  def show
    # @images = @message.images

    # @hash = Gmaps4rails.build_markers(@message) do |message, marker|
    #   marker.lat message.latitude
    #   marker.lng message.longitude
    #   marker.infowindow message.address
    # end
  end

  def edit
    @message = Message.find(params[:id])
  end

  def update
    if @message.update(message_params)
      redirect_back(fallback_location: root_path)
      flash[:success] = 'Статус сообщения успешно изменен!'
    else
      render 'edit'
    end
  end

  def archiving
    @message.status = 'hidden'
    @message.save
    flash[:success] = 'Сообщение успешно удалено!'
    redirect_to root_path
  end

  private

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:body, :latitude, :longitude, :address, :status, :category_id, :sender_name, :sender_id)
  end

  def image_params
    params.require(:image).permit(image: [])
  end
end
