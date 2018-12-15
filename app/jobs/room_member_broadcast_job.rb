class RoomMemberBroadcastJob < ApplicationJob
  queue_as :default

  def perform(room_member)
    #ActionCable.server.broadcast 'room_channel', room_member: render_room_member(room_member)
    RoomChannel.broadcast_to room_member.room, room_member: render_room_member(room_member)
  end
  
  #private
   # def render_room_member(room_member)
    # ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
    # ApplicationController.renderer.render room_member
    #end
end
