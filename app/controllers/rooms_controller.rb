class RoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    @rooms = Room.all
  end
  
  def new 
    @room = Room.new
    @playlist = Playlist.find_by(id: current_user.id)
    
  end
  
  def create
    @room = Room.new(room_params)
    #外すと動く・・・
    #@room.playlist = Playlist.find(params[:playlist_id])
    if @room.save
      flash[:success] = "ルームを作成しました"
      redirect_to rooms_path and return
    else
      flash[:danger] = "ルームの作成に失敗しました"
      render :new and return
    end
  end
  
  def show
    @room = Room.find(params[:id])
  end
  
  def room_params
    params.require(:room).permit(
      :name,
      :description,
      :playlist_id
      );
  end
end
