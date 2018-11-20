class RoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    @rooms = Room.all
  end
  
  
  def get_data(keyword)
  require 'youtube.rb'#先ほど上で準備したファイルを呼ぶ
  opts = Trollop::options do
    opt :p, 'Search term', :type => String, :default => keyword
    #追加するとなぜか動いた。
    # お、すごいですね！bというオプションがなぜか指定されていたのがエラーメッセージの中に
    # あるのを読み解いていただけたようです。
    # 少し謎の多い挙動ですね。
    #https://stackoverflow.com/questions/25048577/unknown-argument-error-p-when-deploying-to-heroku
    #時間外にありがとうございます。何かherokuとtrollopの競合の問題な気がしてきました。わからないですが・・
    # こちらは、pumaの立ち上げの際に呼んでいるオプションですね。pとb。
    # trollopでは許可するオプションをホワイトリストで指定しているのですが、
    # その際にpとbも含めておかないとエラーになるようです。
    # そもそもここでtrollopを利用していることに何か不自然なものを感じますね。
    # 元々のyoutube apiのリファレンスのサンプルコードではコマンドラインからrubyのコードを立ち上げることを意図しているのですが、
    # 強引に訳も分からずrailsに移植しているという印象です。
    # なるほどありがとうございます。youtubeのリファレンスにサンプルコードなど合ったんですね・・
    # あまり、このサイトを参考に進めない方がよろしいでしょうか？？
    # そうですね。
    # こちらがサンプルです。https://developers.google.com/youtube/v3/code_samples/ruby?hl=ja#search_by_keyword
    # これは 
    # $ ruby youtube.rb -q 検索キーワード --max_results 50
    # などのようにコマンドラインからyoutubeのapiを叩くためのサンプルで、
    # コマンドラインのオプション（-qや--max_results）を設定するgemがtrollopです。
    # そのため、今回のコマンドラインのオプションであるpとbを含めておかないとエラーが発生する、というのが今回の問題ですね。
    # エラーメッセージもわかりにくく、難しいデバッグだったと思います。
    # このサイトの作者もそうなのですが、
    # 意図のわかっていないコードをむやみに流用するとこのようなことになります。
    # ですので避けましょう。
    # 東様の理解できるコードだけで今回のサービスであれば十分組み立てられるはずです。
    # では、そろそろ戻りますね！
    # あ、ちなみにこのtrollopを利用している部分は下記のようにできるはずです。
    # ありがとうございました！コマンドラインのものをtrollopはコントローラーにかける処理だったんですね。
    # でもそれが無理やりすぎるのであまりよろしく無いと行った形ですね。
    # trollopはそもそもコントローラで使うのはあまりない気がします。
    # そもそもナンセンスなんですね・・
    # はい！それが理解していただけるだけでも素晴らしいです！
    # ありがとうございます！では
    # またコードを書いていきたいと思います
    # はい！では失礼します！
    # ありがとうございました！
    opt :b,'test',:type => String, :dafaulu => 'test'
    opt :max_results, 'Max results', :type => :int, :default => 50
    opt :order, 'order', :type => String, :default => 'date'
    opt :regionCode, 'region', :type => String, :default => 'JP'
  end
  
  # trollopを書き換え
  # opts = {
  #   q: keyword,
  #   max_results: 50,
  #   order: 'date',
  #   regionCode: 'JP'
  # }

  client, youtube = get_service

  begin

    search_response = client.execute!(
      :api_method => youtube.search.list,
      :parameters => {
        :part => 'snippet',
        :p => opts[:p], # ここは本来:q => opts[:q]
        :maxResults => opts[:max_results],
        :order => opts[:order],
        :regionCode => opts[:regionCode]
      }
    )

  @movies = search_response.data.items#Jsonの中身が多かったので必要な情報のみ受けれるようにしています。

  rescue Google::APIClient::TransmissionError => e
    puts e.result.body
  end
  p @movies
end
  
  def new 
    @room = Room.new
    @playlist = Playlist.find_by(id: current_user.id)
    @pulldown_playlists = Playlist.where(user_id: current_user.id);
  end
  
  def create
    @room = Room.new(room_params)
    #外すと動く・・・
    #@room.playlist = Playlist.find(params[:room][:playlist_id])
    if @room.save
      flash[:success] = "ルームを作成しました"
      redirect_to rooms_path and return
    else
      flash[:danger] = "ルームの作成に失敗しました"
      render :new and return
    end
  end
  
  def show
    @room = Room.find(params[:id])
    @playlist = @room.playlist
  end
  
  def room_params
    params.require(:room).permit(
      :name,
      :description,
      :playlist_id
      );
  end
  
    # 部屋を削除
  def destroy
    @room = Room.find(params[:id])
    @room.destroy
    flash[:success] = "#{@room.name}を削除しました"
    redirect_to rooms_path
  end
end

