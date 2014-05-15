require 'spec_helper'
require 'yt/associations/playlists'

describe Yt::Associations::Playlists, scenario: :device_app do
  let(:account) { Yt.configuration.account }
  let(:title) { 'Yt Test title' }
  let(:description) { 'Yt Test description' }
  let(:tags) { ['Yt Test Tag 1', 'Yt Test Tag 2'] }
  let(:privacy_status) { 'unlisted' }
  let(:params) { {title: title, description: description, tags: tags, privacy_status: privacy_status} }

  describe 'playlists' do
    before { account.create_playlist params }
    after { account.delete_playlists params }

    it { expect(account.playlists.count).to be > 0 }
    it { expect(account.playlists.first).to be_a Yt::Playlist }
  end

  describe 'create a playlist' do
    after { account.delete_playlists params }

    it { expect(account.create_playlist params).to be_a Yt::Playlist }
    it { expect{account.create_playlist params}.to change{account.playlists.count}.by(1) }
  end

  describe 'delete a playlist' do
    let(:title) { "Yt Test Delete Playlist #{rand}" }
    before { @playlist = account.create_playlist params }

    it { expect(@playlist.delete).to be true }
  end

  describe 'delete a set of playlists' do
    let(:title) { "Yt Test Delete All Playlists #{rand}" }
    before { account.create_playlist params }

    it { expect(account.delete_playlists title: %r{#{params[:title]}}).to eq [true] }
    it { expect(account.delete_playlists params).to eq [true] }
    it { expect{account.delete_playlists params}.to change{account.playlists.count}.by(-1) }
  end

  describe 'update a playlist' do
    before { @playlist = account.create_playlist params }
    after { @playlist.delete }

    context 'changes the attributes that are specified to be updated' do
      let(:new_attrs) { {title: "Yt Test Update Playlist #{rand}"} }
      it { expect(@playlist.update new_attrs).to eq true }
      it { expect{@playlist.update new_attrs}.to change{@playlist.title} }
    end

    context 'does not changes the attributes that are not specified to be updated' do
      let(:new_attrs) { {} }
      it { expect(@playlist.update new_attrs).to eq true }
      it { expect{@playlist.update new_attrs}.not_to change{@playlist.title} }
      it { expect{@playlist.update new_attrs}.not_to change{@playlist.description} }
      it { expect{@playlist.update new_attrs}.not_to change{@playlist.tags} }
      it { expect{@playlist.update new_attrs}.not_to change{@playlist.privacy_status} }
    end
  end
end
