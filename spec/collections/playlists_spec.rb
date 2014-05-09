require 'spec_helper'
require 'yt/collections/playlists'

describe Yt::Collections::Playlists do
  subject(:collection) { Yt::Collections::Playlists.new }

  describe '#insert' do
    let(:playlist) { Yt::Playlist.new }
    # TODO: separate stubs to show options translate into do_insert params
    before { collection.stub(:do_insert).and_return playlist }

    it { expect(collection.insert).to eq playlist }
  end

  describe '#delete_all' do
    before { collection.stub(:do_delete_all).and_return [true] }

    it { expect(collection.delete_all).to eq [true] }
  end

  describe '#delete_all' do
    before { collection.stub(:do_delete_all).and_return [true] }

    it { expect(collection.delete_all).to eq [true] }
  end
end