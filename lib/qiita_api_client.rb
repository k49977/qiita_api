class QiitaApiClient
  class HTTPError < StandardError
    def initialize(message)
      super "connection failed: #{message}"
    end
  end

  class << self
    def connection
      Faraday::Connection.new('https://qiita.com') do |builder|
        builder.authorization :Bearer, "#{Rails.application.credentials.qiita[:token]}"
        builder.request  :url_encoded # リクエストパラメータを URL エンコードする
        builder.response :logger # レスポンスを標準出力する
        builder.adapter Faraday.default_adapter # アダプターの選択。デフォルトはNet::HTTP
        builder.response :json, :content_type => "application/json" # レスポンスボディをJSONパースする
      end
    end

    def search_item_titles(word)
      response = connection.get('/api/v2/items')
      item_titles = response.body.pluck('title') # レスポンスボディのうちtitleプロパティのみを抽出
      item_titles.select { |title| title.include? "#{word}" } # wordが含まれるtitleのみを返す
    end
  end
end