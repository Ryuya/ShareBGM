def main
  opts = Trollop::options do
    opt :p, 'Search term', :type => String, :default => '検索ワード' #defaoultの内容を検索したいワードにする。
    opt :max_results, 'Max results', :type => :int, :default => 25 #検索結果数を決める（最大50まで）
    opt :order, 'order', :type => String, :default => 'viewCount' #視聴回数の多い順にデータを取得する。
  end

  client, youtube = get_service

  begin

    search_response = client.execute!(
      :api_method => youtube.search.list,
      :parameters => {
        :part => 'snippet',
        :p => opts[:p],#上記の検索ワードを変換する
        :maxResults => opts[:max_results],#上記の取得数を変換する
        :order => opts[:order],#上記の取得順を変換する
      }
    )
  puts search_response

  rescue Google::APIClient::TransmissionError => p
    puts p.result.body
  end
end