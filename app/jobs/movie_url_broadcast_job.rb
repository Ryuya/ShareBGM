class MovieUrlBroadcastJob < ApplicationJob
  queue_as :default
  
  def perform(movie_url)
    p movie_url
    p "テスト"
    #ActionCable.server.broadcast 'room_channel', room_chat_log: render_room_chat_log(room_chat_log)
    RoomChannel.broadcast_to movie_url.playlist.room, movie_url: render_movie_url(movie_url)
  end

  private
    def render_movie_url(movie_url)
      # ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
      ApplicationController.renderer.render movie_url
    end
end
