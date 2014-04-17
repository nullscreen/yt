require 'spec_helper'
require 'googol/youtube_account'

describe Googol::YoutubeAccount do
  context 'given a valid account authentication' do
    before :all do
      auth_params = {refresh_token: ENV['GOOGOL_TEST_YOUTUBE_REFRESH_TOKEN']}
      @account = Googol::YoutubeAccount.new auth_params
      @attrs = {title: 'Googol Test'}
    end

    context 'given there is no playlist called "Googol Test"' do
      before { @account.delete_playlists! @attrs }
      it 'allows to create a playlist called "Googol Test"' do
        expect(@account.create_playlist! @attrs).to be
      end
    end

    context 'given there is a playlist called "Googol Test"' do
      before do
        @id = @account.find_or_create_playlist_by @attrs
      end

      it 'allows to find the playlist by string-matching' do
        expect(@account.find_playlist_by title: 'Googol Test').to eq @id
      end

      it 'allows to find the playlist by regex-matching' do
        expect(@account.find_playlist_by title: /ol test$/i).to eq @id
      end

      it 'allows to update the playlist given at least a title' do
        attrs = {title: 'Googol Test', description: 'Test', public: false}
        expect(@account.update_playlist! @id, attrs).to eq @id
      end

      it 'does not allow to update the playlist without a new title' do
        attrs = {description: 'Googol Test', public: true}
        expect{@account.update_playlist! @id, attrs}.to raise_error Googol::RequestError
      end

      it 'allows to delete the playlist' do
        expect(@account.delete_playlists! title: /ol test$/i).to be_one
      end
    end

    context 'given there is more than one "page" of playlists' do
      before do
        @account.find_or_create_playlist_by title: 'Googol Page 1'
        @account.find_or_create_playlist_by title: 'Googol Page 2'
      end

      it ' allows to find a playlist in the second page' do
        expect(@account.find_playlist_by title: 'Googol Page 2', max: 1).to be
      end
    end
  end
end