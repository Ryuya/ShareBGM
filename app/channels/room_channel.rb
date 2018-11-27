class RoomChannel < ApplicationCable::Channel
  def subscribed
     stream_from "room_channel"
     #stream_for room/21
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def sync(data)
    ActionCable.server.broadcast 'room_channel', time: data['time'] , id: data['id']
  end
  
  def speak(data)
    ActionCable.server.broadcast 'room_channel', message: data['message']
  end
end
