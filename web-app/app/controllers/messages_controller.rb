class MessagesController < ApplicationController
  before_action :set_message, only: [:update, :show, :edit, :archiving]
  before_action :role_required, except: [:create]  # проверяет роль юзера
  skip_before_action :authenticate_user!, only: [:create]

  def index
    @status = params[:status] if !params[:status].nil?
    @messages = Message.all.order(created_at: :desc)
    @hash = Gmaps4rails.build_markers(@messages) do |message, marker|
      marker.lat message.latitude
      marker.lng message.longitude
      marker.infowindow message.address
    end
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.create(message_params)
    puts params[:image][:image] 
    params[:image][:image].each do |file|
      @message.images.create(image: file)
    end
  end

  def show
    @hash = Gmaps4rails.build_markers(@message) do |message, marker|
      marker.lat message.latitude
      marker.lng message.longitude
      marker.infowindow message.address
  end

  def edit
    end
  end

  def update
    if @message.update(message_params)
      redirect_back(fallback_location: root_path)
    else
      render 'edit'
    end
  end

  def archiving
    @message.status = "hidden"
    @message.save
    redirect_to root_path
  end

  private
  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:body, :latitude, :longitude, :address, :status, :category_id)
  end

  def image_params
    params.require(:image).permit({image: []}) 
  end

end
