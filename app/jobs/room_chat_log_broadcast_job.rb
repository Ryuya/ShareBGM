class RoomChatLogBroadcastJob < ApplicationJob
  queue_as :default
  
  def perform(room_chat_log)
    
    #ActionCable.server.broadcast 'room_channel', room_chat_log: render_room_chat_log(room_chat_log)
    RoomChannel.broadcast_to room_chat_log.room, room_chat_log: render_room_chat_log(room_chat_log)
  end

  private
    def render_room_chat_log(room_chat_log)
      # ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
      ApplicationController.renderer.render room_chat_log
    end
    
end
