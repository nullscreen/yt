require 'spec_helper'
require 'yt/associations/playlists'

describe Yt::Associations::Playlists, :device_app do
  let(:title) { 'Yt Test title' }
  let(:description) { 'Yt Test description' }
  let(:tags) { ['Yt Test Tag 1', 'Yt Test Tag 2'] }
  let(:privacy_status) { 'unlisted' }
  let(:params) { {title: title, description: description, tags: tags, privacy_status: privacy_status} }

  describe 'delete a playlist' do
    let(:title) { "Yt Test Delete Playlist #{rand}" }
    before { @playlist = $account.create_playlist params }

    it { expect(@playlist.delete).to be true }
  end

  describe 'update a playlist' do
    before { @playlist = $account.create_playlist params }
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
