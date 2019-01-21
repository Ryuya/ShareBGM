$ -> 
  App.room = App.cable.subscriptions.create {channel: "RoomChannel", id: $("#room").data('room_id'), user_id: $("#room").data("user_id")},
    connected: (room_id,user_id) ->
      # Called when the subscription is ready for use on the server
      # App.room.join $("#room").data('room_id') , $("#room").data('user_id'), $("#memberNum").data('membernum')
    disconnected: (room_id,user_id) ->
      # Called when the subscription has been terminated exiby the server
      # App.room.leave $("#room").data('room_id') , $("#room").data('user_id')
      
    received: (data) ->
      # Called when there's incoming data on the websocket for this channel
      if data['room_chat_log'] != undefined
        $('.loges').append data['room_chat_log']
        $('.loges').animate { scrollTop: $('.loges')[0].scrollHeight }, 'fast'
        
      if data['movie_url'] != undefined
        $("#playlist").append data['movie_url']
        $.getScript("javascriptd/room_show.js")
        $('#playlist li').last().addEventListener("click",addClicEvent(), false)
        
         
      if data['time'] != undefined
        App.yt_player.loadVideoById(data['id'],Number(data['time']))
        App.yt_player.playVideo()
        console.log(data['time'])
          
      if data["memberNum"] != undefined
        console.log(data["memberNum"])
        $("#memberNum").text(data['memberNum']+"人")

      
      if data["subscribed"] == true && $("#room").data("host_user") != undefined && App.yt_player.getCurrentTime() != undefined
        console.log($("#room").data("host_user"))
        App.room.sync App.yt_player.getCurrentTime(), App.yt_player.getVideoData()['video_id'], $("#room").data('room_id')
        

        
    sync:(time,id,room_id) ->
      @perform 'sync', time: time ,id: id, room_id: room_id
      
    speak: (log,room_id,user_id) ->
      @perform 'speak', log: log , room_id: room_id , user_id: user_id
      
    join: () ->
      @perform 'join'
      
    movie_create: (url,room_id,user_id)->
      console.log('url:' + url)
      console.log('room_id:' + room_id)
      console.log('user_id:' + user_id)
      @perform 'movie_create', url: url, room_id: room_id, user_id: user_id
      
$(document).on 'click', '.syncbutton', ->
  App.room.sync App.yt_player.getCurrentTime(), App.yt_player.getVideoData()['video_id'], $("#room").data('room_id')


$(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
  #
  # バリデーションチェックや、データの加工を行う。
  #
  if event.keyCode is 13
    App.room.speak event.target.value, $("#room").data('room_id'), $("#room").data('user_id')
    event.target.value = ''
    event.preventDefault()
    
$(document).on 'click', '[data-behavior~=room_syncer]', (event) ->
  App.room.movie_create document.forms.new_movie_url.movie_url_url.value,$("#room").data('room_id'),$("#room").data('user_id')
  document.forms.new_movie_url.movie_url_url.value = ''
  event.preventDefault()
  #
  # バリデーションチェックや、データの加工を行う。
  #
  #App.room.speak event.target.value, $("#room").data('room_id'), $("#room").data('user_id')
  #event.target.value = ''
  #event.preventDefault()
    #sampleElement = $('.loges')
    #value = sampleElement.scrollHeight

    
    #maxScrollValue = @scrollHeight - (@offsetHeight)
    
    #$(sampleElement).scrollTop maxScrollValue
    #sampleElement.onscroll = ->
    #maxScrollValue = @scrollHeight
    #$(sampleElement).scrollTop maxScrollValue

