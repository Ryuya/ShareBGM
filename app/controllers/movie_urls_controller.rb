class MovieUrlsController < ApplicationController
  def index
  end
  
  def create
    p params
    @playlist = Playlist.find(params[:movie_url][:playlist_id])
    
    # @playlist.movie_urls.each do |movie_url|
    #   movie_url.destroy
    # end
    
    # @playlist.reload
    
    @movie_url = @playlist.movie_urls.create(movie_url_params)
    
    @movie_url.user_id = current_user.id
    @movie_url.ytid = url_to_ytid(@movie_url.url)
    @movie_url.title = get_title(@movie_url.ytid)
    
    if @playlist.save
      flash[:success] = "プレイリストを更新しました"
      redirect_to controller: 'rooms', action: 'show', id: params[:movie_url][:room_id] and return
    else
      flash.now[:danger] = "プレイリストの更新に失敗しました"
      redirect_to controller: 'rooms', action: 'show', id: params[:movie_url][:room_id] and return
    end
  end
  private
  
    def movie_url_params
      params.require(:movie_url).permit(
        :url,
      );
    end
    
    def url_to_ytid(url)
      url.sub("https://www.youtube.com/watch?v=","").sub(/&.*/m, "")
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
      #rescue Google::APIClient::TransmissionError => e
      #  puts e.result.body
      end
      return videos
    end
    
    def playlist_params
    params.require(:playlist).permit(
      :name,
      :description,
      movie_urls_attributes: [
        :id,
        :url,
        :title,
        :description,
        :_destroy
      ],
    );
  end
end
