class MovieUrl < ApplicationRecord
  belongs_to :playlist
  belongs_to :user
  
  before_save :fetch_yt_info
  after_create_commit { MovieUrlBroadcastJob.perform_later self }

  validates :url, presence: true
  validates :title, presence: false,length: {maximum: 80}
  validates :description, presence: false,length: {maximum: 350}
  
  def image_url
    "https://i.ytimg.com/vi/" + ytid + "/default.jpg"
  end
  
  def fetch_yt_info
    fetch_ytid
    fetch_title
  end
  
  def fetch_ytid
    self.ytid = url.sub("https://www.youtube.com/watch?v=","").sub(/&.*/m, "")
  end
    
  def fetch_title
    require 'youtube.rb'
    client, youtube = get_service
    id = ytid
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
    self.title = videos
  end
end
