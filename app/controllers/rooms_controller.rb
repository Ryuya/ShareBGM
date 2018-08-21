class RoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    @rooms = Room.all
  end
  
  def new 
    @room = Room.new
  end
  
  def create
    @room = Room.new(room_params)
    
    if @room.save
      flash[:success] = "ルームを作成しました"
      redirect_to rooms_path and return
    else
      flash[:danger] = "ルームの作成に失敗しました"
      render :new and return
    end
  end
  
  def show
    
  end
  
  def room_params
    params.require(:room).permit(
      :name,
      :description
      );
  end
end
