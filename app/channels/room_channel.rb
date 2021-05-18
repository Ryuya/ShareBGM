class RoomChannel < ApplicationCable::Channel
  def subscribed
    #stream_from "room_channel"
    @room = Room.find(params[:id])
    @user = User.find(params[:user_id])
    if @room != nil
      stream_for @room
      #同じユーザーがかぶって居たらcreateしない
      hash = RoomMember.group(:@user_id).having('count(*) >= 2').maximum(:created_at)
      user_ids = RoomMember.where(user_id: hash.keys, created_at: hash.values).pluck(:@user_id)
      RoomMember.where(user_id: @user.id).where.not(id: user_ids).destroy_all
      @room.room_members.create! user_id: @user.id

      RoomChannel.broadcast_to @room, memberNum: @room.room_members.count
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed


    RoomMember.where(user_id: @user.id).destroy_all

    @room.room_members.create! user_id: @user.id

    RoomChannel.broadcast_to @room, memberNum: @room.room_members.count
    # if @room.present?
    #   p @room.name
    # end
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
  
  def movie_create(data)
    p "テスト"
    p data
    room = Room.find(data['room_id'])
    MovieUrl.create! playlist_id: room.playlist_id, url: data["url"],user_id: data["user_id"]
  end
  
  def join()
    # room = Room.find(data['room_id'])
    # room.room_members.create! room_id: data['room_id'],user_id: data['user_id']
    # #RoomMember.delete_all
    # RoomChannel.broadcast_to room, memberNum: data['memberNum']
    RoomChannel.broadcast_to @room , subscribed: true
  end
  
  def leave(data)
    # room = Room.find(data['room_id'])
    # room.room_members.where(user_id: data['user_id']).destroy
    # RoomChannel.broadcast_to room, memberNum: data['memberNum']
  end
end
