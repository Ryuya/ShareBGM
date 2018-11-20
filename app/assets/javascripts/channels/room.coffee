App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data['time'] == undefined
      return
    else
        gon.player.seekTo(data['time'])
        gon.player.loadVideoById(data['id'])
        gon.player.playVideo()
        console.log(data['time'])
        
  sync:(time,id) ->
    @perform 'sync', time: time ,id: id
    
$(document).on 'click', '.syncbutton', ->
  
  App.room.sync gon.player.getCurrentTime() , gon.player.getVideoData()['video_id']
  
  
