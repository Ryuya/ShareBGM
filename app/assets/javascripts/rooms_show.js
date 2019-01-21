/* global $ YT */
let index = 0;
$(document).on('ready',function(){
  
  let controller = $('body').data('controller');
  let action = $('body').data('action');
  console.log("controller:"+controller + ",action:"+action);
  
  //show.html.erbにulを用意しておく。
  if(controller === "rooms" && action === "show"){
    
    $.getScript("https://www.youtube.com/iframe_api")

    let itemHTML = '<div class="glyphicon glyphicon-refresh syncbutton style="top:8px;" ></div>';
    $('header').append(itemHTML);
    let videoId = getMovieIdByIndex(0);
    
    window.onYouTubeIframeAPIReady = function() {
      console.log(App);
      //gon.player = new YT.Player('player', {
      App.yt_player =  new YT.Player('player', {
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

var huga = 0;
var hoge = setInterval(function() {
    console.log(huga);
    huga++;
    //終了条件
    if (huga == 1) {
    clearInterval(hoge);
    App.room.join();
    console.log("終わり");
    }
}, 1700);

// 4. The API will call this function when the video player is ready.
function onPlayerReady(event) {
  addClickEvent();
  hoge();

  $('.syncbutton').on('click',function(){
    console.log("ブロードキャスト");
    //playMovieByIndex(index);
    //App.yt_player.playVideo();

  });
  //playMovieByIndex(index);
  //stopVideo();
}

function addClickEvent(){
  $('#playlist li').on('click',function(){
    index =  $('#playlist li').index(this);
    playMovieByIndex(index,0);
  });
}

//五行以内に関数名がその処理そのもの
function playMovieByIndex(index,videoTime = 0){
  $(".playing").removeClass("playing");
  $('#playlist li').eq(index).addClass("playing");
  App.yt_player.loadVideoById(getMovieIdByIndex(index),videoTime,"default");
  App.yt_player.playVideo();
}

function getMovieIdByIndex(index){
  return $('#playlist li').eq(index).data("movie_id");
}

function nextVideo(){
  index = (index === $("#playlist li").length - 1) ? 0 : index + 1;
  playMovieByIndex(index,0);
}

function stopVideo() {
  App.yt_player.stopVideo();
}
function onPlayerStateChange(event) {
  var ytStatus = event.data;
  if (ytStatus == YT.PlayerState.ENDED) {
      nextVideo();
  }
}