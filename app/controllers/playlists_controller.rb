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
      ytid = movie_url.url
      ytid.slice!("https://www.youtube.com/watch?v=")
      ytid.sub!(/&.*/m, "")
      movie_url.ytid = ytid
      if movie_url.title == "" 
        movie_url.title = get_title(ytid)
      end
    end
    #renderとridirectを分ける
    if @playlist.save
      flash[:success] = "プレイリストを作成しました"
      redirect_to playlists_url and return
    else
      flash.now[:danger] = "プレイリストの作成に失敗しました"
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
  
  def get_title(id)
    require 'youtube.rb'
    client, youtube = get_service
    
    opts = Trollop::options do
      opt :q, id, :type => String, :default => id
      opt :b, "test", :type => String, :default =>"test"
      opt :p, "test", :type => String, :default =>"test"
      opt :max_results, 'Max results', :type => :int, :default => 1
    end

    client, youtube = get_service
  
    begin
      # Call the search.list method to retrieve results matching the specified
      # query term.
      search_response = client.execute!(
        :api_method => youtube.search.list,
        :parameters => {
          :part => 'snippet',
          :q => opts[:q],
          :maxResults => opts[:max_results]
        }
      )
      
      videos = []
      channels = []
      playlists = []
  
      # Add each result to the appropriate list, and then display the lists of
      # matching videos, channels, and playlists.
      search_response.data.items.each do |search_result|
        case search_result.id.kind
          when 'youtube#video'
            videos << "#{search_result.snippet.title}"
          when 'youtube#channel'
            channels << "#{search_result.snippet.title} (#{search_result.id.channelId})"
          when 'youtube#playlist'
            playlists << "#{search_result.snippet.title} (#{search_result.id.playlistId})"
        end
      end
  
      puts "Videos:\n", videos, "\n"
      puts "Channels:\n", channels, "\n"
      puts "Playlists:\n", playlists, "\n"
      
      
      
    rescue Google::APIClient::TransmissionError => e
      puts e.result.body
    end
    return videos
  end
  
  
end
