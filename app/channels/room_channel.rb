class RoomChannel < ApplicationCable::Channel
  def subscribed
    #stream_from "room_channel"
    room = Room.find(params[:id])
    stream_for room
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    room = Room.find(params[:id])
    room.room_members.where(user_id: current_user.id).destroy
    RoomChannel.broadcast_to room, memberNum: data['memberNum']
  end

  def sync(data)
    room = Room.find(data['room_id'])
    #ActionCable.server.broadcast 'room_channel', time: data['time'] , id: data['id']
    RoomChannel.broadcast_to room, time: data['time'] , id: data['id']
  end
  
  def speak(data)
    room = Room.find(data['room_id'])
    #ActionCable.server.broadcast 'room_channel', message: data['message']
    #RoomChannel.broadcast_to room, message: data['message']
    RoomChatLog.create! log: data['log'] ,room_id: data['room_id'],user_id: data['user_id']
  end
  
  def join(data)
    room = Room.find(data['room_id'])
    room.room_members.create! room_id: data['room_id'],user_id: data['user_id']
    #RoomMember.delete_all
    RoomChannel.broadcast_to room, memberNum: data['memberNum']
  end
  
  def leave(data)
    room = Room.find(data['room_id'])
    room.room_members.where(user_id: data['user_id']).destroy
    RoomChannel.broadcast_to room, memberNum: data['memberNum']
  end
end
