require 'spec_helper'
require 'yt/models/search'

describe Yt::Search, :server_app do
  subject(:search) { Yt::Search.new query  }

  context 'given a specific query' do
    let(:query) { 'railsconf 2014 keynote' }

    it { expect(search.videos).to be_a Yt::Collections::Videos }

    it 'returns at least one result' do
      expect(search.videos.first).to be_a Yt::Video
    end
  end
end
