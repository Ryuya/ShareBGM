/* global $ YT */
let index = 0;

$(document).on('ready',function(){
  let controller = $('body').data('controller');
  let action = $('body').data('action');
  console.log("controller:"+controller + ",action:"+action);
  
  //show.html.erbにulを用意しておく。
  if(controller === "rooms" && action === "show"){
    
    $.getScript("https://www.youtube.com/iframe_api")
    // }
    let itemHTML = '<div class="glyphicon glyphicon-refresh syncbutton style="top:8px;" ></div>';
    $('header').append(itemHTML);
    let videoId = getMovieIdByIndex(0);
    
    window.onYouTubeIframeAPIReady = function() {
      gon.player = new YT.Player('player', {
        height: '360',
        width: '640',
        videoId: videoId,
        events: {
          'onReady': onPlayerReady,
          'onStateChange': onPlayerStateChange
        }
      });
    }
  }
});
// 4. The API will call this function when the video player is ready.
function onPlayerReady(event) {
  $('#playlist li').on('click',function(){
    index =  $('#playlist li').index(this);
    playMovieByIndex(index);
  });
  $('.syncbutton').on('click',function(){
    console.log("ブロードキャスト");
  });
  //SeeqTo()を使う
  playMovieByIndex(index);
  gon.player.playVideo();
}

//五行以内に関数名がその処理そのもの
function playMovieByIndex(index){
  $(".playing").removeClass("playing");
  $('#playlist li').eq(index).addClass("playing");
  gon.player.loadVideoById(getMovieIdByIndex(index),0,"default");
  gon.player.seekTo(0,true);
  
}

function getMovieIdByIndex(index){
  return $('#playlist li').eq(index).data("movie_id");
}

function nextVideo(){
  index = (index === $("#playlist li").length - 1) ? 0 : index + 1;
  playMovieByIndex(index);
}

function stopVideo() {
  gon.player.stopVideo();
}
function onPlayerStateChange(event) {
  var ytStatus = event.data;
  if (ytStatus == YT.PlayerState.ENDED) {
      nextVideo();
  }
}