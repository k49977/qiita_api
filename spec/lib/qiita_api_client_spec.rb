require 'rails_helper'

describe 'QiitaApiClient' do

  describe '.search_item_titles' do
    let(:response_body) { [{ "title" => "hoge" }, { "title" => "fuga" }] }
    before do
      connection_mock = double('connection_mock')
      response_mock = double('response_mock', status: 200, body: response_body)
      allow(connection_mock).to receive(:get).and_return(response_mock)
      allow(QiitaApiClient).to receive(:connection).and_return(connection_mock)
    end
    context '検索がヒットした場合' do
      it 'データが取得できること' do
        response = QiitaApiClient.search_item_titles('hoge')
        expect(response.count).to eq 1
      end
    end
    context '検索がヒットしない場合' do
      it 'データが取得できないこと' do
        response = QiitaApiClient.search_item_titles('xxx')
        expect(response.count).to eq 0
      end
    end
  end
end