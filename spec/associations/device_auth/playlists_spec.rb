require 'spec_helper'
require 'yt/associations/playlists'

describe Yt::Associations::Playlists, scenario: :device_app do
  let(:account) { Yt.configuration.account }

  describe '#playlists' do
    let(:params) { {title: "Yt Test Playlists" } }
    before { account.create_playlist params }
    after { account.delete_playlists params }

    it { expect(account.playlists.count).to be > 0 }
    it { expect(account.playlists.first).to be_a Yt::Playlist }
  end

  describe '#create_playlist' do
    let(:params) { {title: "Yt Test Create Playlist" } }
    after { account.delete_playlists params }

    it { expect(account.create_playlist params).to be_a Yt::Playlist }
    it { expect{account.create_playlist params}.to change{account.playlists.count}.by(1) }
  end

  describe '#delete_playlists' do
    let(:params) { {title: "Yt Test Delete Playlist #{rand}" } }
    before { account.create_playlist params }

    it { expect(account.delete_playlists title: %r{#{params[:title]}}).to eq [true] }
    it { expect(account.delete_playlists params).to eq [true] }
    it { expect{account.delete_playlists params}.to change{account.playlists.count}.by(-1) }
  end

  describe 'update a playlist' do
    let(:old_title) { "Yt Test Before Update Playlist" }
    let(:new_title) { "Yt Test After Update Playlist" }
    before { @playlist = account.create_playlist title: old_title }
    after { @playlist.delete }

    it { expect(@playlist.update title: new_title).to eq true }
    it { expect{@playlist.update title: new_title}.to change{@playlist.title} }
    it { expect{@playlist.update privacy_status: 'unlisted'}.to change{@playlist.privacy_status} }
  end
end