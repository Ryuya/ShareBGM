class PlaylistsController < ApplicationController
  def index
    @playlists = Playlist.all
  end
  
  def new
    @have_playlists = Playlist.where(user_id: current_user.id)
    @playlists = Playlist.all
    @playlist = Playlist.new
    3.times do
      @playlist.movie_urls.new
    end
  end
  
  def create
    @playlist = Playlist.new(playlist_params)
    @playlist.user_id = current_user.id
    @playlist.movie_urls.each do |movie_url|
      movie_url.user_id = current_user.id
    end
    #renderとridirectを分ける
    if @playlist.save
      flash[:success] = "プロジェクトを作成しました"
      redirect_to playlists_url and return
    else
      flash.now[:danger] = "プロジェクトの作成に失敗しました"
      render :new and return
    end
  end
  
  def show
    @playlist = Playlist.find(params[:id])
  end
  
  def edit
    @playlist = Playlist.find(params[:id])
    

    (3 - @playlist.movie_urls.size).times do
      @playlist.movie_urls.new
    end
    
  end
  
  def update
    @playlist = Playlist.find(params[:id])
    
    @playlist.movie_urls.each do |movie_url|
      movie_url.destroy
    end
    
    @playlist.reload
    
    @playlist.assign_attributes(playlist_params)
    
    @playlist.movie_urls.each do |movie_url|
      movie_url.user_id = current_user.id
    end
    
    if @playlist.save
      flash[:success] = "プロジェクトを更新しました"
      redirect_to edit_playlist_path and return
    else
      flash.now[:danger] = "プロジェクトの更新に失敗しました"
      render :edit and return
    end
  end
  
  # 投稿を削除
  def destroy
    @playlist = Playlist.find(params[:id])
    @playlist.destroy
    flash[:success] = "#{@playlist.name}を削除しました"

    redirect_to playlists_path
  end
  
  def playlist_params
    params.require(:playlist).permit(
      :name,
      :description,
      movie_urls_attributes: [
        :url,
        :title,
        :description
      ],
    );
  end
end
