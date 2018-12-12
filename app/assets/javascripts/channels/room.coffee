$ -> 
  App.room = App.cable.subscriptions.create {channel: "RoomChannel", id: $("#room").data('room_id')},
    connected: ->
      # Called when the subscription is ready for use on the server
  
    disconnected: ->
      # Called when the subscription has been terminated by the server
  
    received: (data) ->
      # Called when there's incoming data on the websocket for this channel
      if data['room_chat_log'] == undefined
        console.log("Time");
      else
        #alert data['room_chat_log']
        $('.loges').append data['room_chat_log']
        
      if data['time'] == undefined
        console.log("Message");
      else
          App.yt_player.loadVideoById(data['id'],Number(data['time']))
          console.log(data['time'])
      
    sync:(time,id,room_id) ->
      @perform 'sync', time: time ,id: id, room_id: room_id
      
    speak: (log,room_id,user_id) ->
      @perform 'speak', log: log , room_id: room_id , user_id: user_id
      
$(document).on 'click', '.syncbutton', ->
  
  App.room.sync App.yt_player.getCurrentTime() , App.yt_player.getVideoData()['video_id'], $("#room").data('room_id')
  
# setTimeout

$(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
  #
  # バリデーションチェックや、データの加工を行う。
  #
  if event.keyCode is 13
    App.room.speak event.target.value, 
    event.target.value = ''
    event.preventDefault()
