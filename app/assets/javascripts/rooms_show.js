$(document).on('ready',function(){
  let controller = $('body').data('controller');
  let action = $('body').data('action');
  
  console.log("controller:"+controller + ",action:"+action);
  //show.html.erbにulを用意しておく。
  if(controller === "rooms" && action === "show"){
    
    if (window.YT) {
      window.onYouTubeIframeAPIReady && window.onYouTubeIframeAPIReady();
      return;
    }else{
      $.getScript("https://www.youtube.com/iframe_api")
    }
    window.onYouTubeIframeAPIReady = function() {
      $('#playlist li').each(function(index,elm) {
        console.log($(elm).data('movie_id'));
        gon.ids.push($(elm).data('movie_id'));
      });
      gon.currentId = 0;
      gon.player = new YT.Player('player', {
        height: '360',
        width: '640',
        videoId: gon.ids[gon.currentId],
        events: {
          'onReady': onPlayerReady,
          'onStateChange': onPlayerStateChange
        }
      });
      $('#playlist li').each(function(index,elm) {
        if(index == gon.currentId){
          $(elm).addClass("playing");
        }
    });
    }
    
    // 4. The API will call this function when the video player is ready.
    function onPlayerReady(event) {
      event.target.playVideo();
    }
    
    
  
  
    // 5. The API calls this function when the player's state changes.
    //    The function indicates that when playing a video (state=1),
    //    the player should play for six seconds and then stop.
    var done = false;
    function onPlayerStateChange(event) {
      // if (event.data == YT.PlayerState.PLAYING && !done) {
      //   setTimeout(stopVideo, 6000);
      //   done = true;
      // }
      var ytStatus = event.data;
      // 再生終了したとき
      //js.erb
      //データ属性を使う
      if (ytStatus == YT.PlayerState.ENDED) {
          gon.currentId = gon.currentId + 1;
          gon.player.cueVideoById(gon.ids[gon.currentId],0,"default");
          $(".playing").removeClass("playing");
          $("#playlist li").each(function(index,elm){
            if(index == gon.currentId){
              $(elm).addClass("playing");
            }
          });
          gon.player.playVideo();
      }
    }
    
    function stopVideo() {
      gon.player.stopVideo();
    }
  }
})