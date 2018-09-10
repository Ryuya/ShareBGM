$(document).on('ready',function(){
  let controller = $('body').data('controller');
  let action = $('body').data('action');
  console.log("controller:"+controller + ",action:"+action);
  //ids = <%= %>
  //show.html.erbにulを用意しておく。
  let ids = ["A2k6ZO6B0A8","CurkP_8S0bI","XSkpuDseenY"];
  let counter = 0;
  if(controller === "rooms" && action === "show"){
      // 2. This code loads the IFrame Player API code asynchronously.
    var tag = document.createElement('script');
  
    tag.src = "https://www.youtube.com/iframe_api";
    var firstScriptTag = document.getElementsByTagName('script')[0];
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
  
    // 3. This function creates an <iframe> (and YouTube player)
    //    after the API code downloads.
    var player;
    $(window).on('load',function(){
      //イディオム 短絡評価
      onYouTubeIframeAPIReady && onYouTubeIframeAPIReady();
    })
    
    
    function onYouTubeIframeAPIReady() {
      player = new YT.Player('player', {
        height: '360',
        width: '640',
        videoId: ids[counter],
        events: {
          'onReady': onPlayerReady,
          'onStateChange': onPlayerStateChange
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
          counter = counter + 1;
          player.cueVideoById(ids[counter],0);
          console.log(counter);
          player.playVideo();
      }
      
    }
    function stopVideo() {
      player.stopVideo();
    }
  }
})