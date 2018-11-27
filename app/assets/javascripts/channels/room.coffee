App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data['message'] == undefined
      console.log("Time");
    else
      alert data['message']
      
    if data['time'] == undefined
      console.log("Message");
    else
        App.yt_player.loadVideoById(data['id'],Number(data['time']))
        console.log(data['time'])
    
  sync:(time,id) ->
    @perform 'sync', time: time ,id: id
    
  speak: (message) ->
    @perform 'speak', message: message
    
$(document).on 'click', '.syncbutton', ->
  
  App.room.sync App.yt_player.getCurrentTime() , App.yt_player.getVideoData()['video_id']
  
# setTimeout

$(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
  #
  # バリデーションチェックや、データの加工を行う。
  #
  if event.keyCode is 13
    App.room.speak event.target.value 
    event.target.value = ''
    event.preventDefault()
  #バリデーションチェックの結果submitしない場合、return falseすることでsubmitを中止することができる。
