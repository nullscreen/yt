require 'spec_helper'
require 'googol/youtube_account'

describe Googol::YoutubeAccount do
  context 'given a valid account authentication' do
    before :all do
      auth_params = {refresh_token: ENV['GOOGOL_TEST_YOUTUBE_REFRESH_TOKEN']}
      @account = Googol::YoutubeAccount.new auth_params
      @video_id = 'Kd5M17e7Wek' # Tongue by R.E.M.
    end

    context 'given there is a playlist called "Googol Test"' do
      before do
        @playlist_id = @account.find_or_create_playlist_by title: 'Googol Test'
      end

      it 'allows to add an item to the playlist' do
        expect(@account.add_item_to! @playlist_id, video_id: @video_id).to be
      end

      it 'allows to add a list of videos to the playlist' do
        expect(@account.add_videos_to! @playlist_id, [@video_id]*2).to be
      end

      context 'given there is more than one "page" of playlist items' do
        before do
          @account.add_item_to! @playlist_id, video_id: @video_id
          @account.add_item_to! @playlist_id, video_id: @video_id
        end

        it 'allows to remove all items from the playlist' do
          expect(@account.remove_all_items_from! @playlist_id, max: 1).to be
        end
      end
    end
  end
end