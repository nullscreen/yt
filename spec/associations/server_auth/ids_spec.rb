require 'spec_helper'
require 'yt/associations/ids'

describe Yt::Associations::Ids, scenario: :server_app do
  subject(:resource) { Yt::Resource.new url: url }

  describe 'id and username' do
    context 'given a URL containing an existing username' do
      let(:url) { 'youtube.com/fullscreen' }
      it { expect(resource.id).to eq 'UCxO1tY8h1AhOz0T4ENwmpow' }
    end

    context 'given a URL containing an unknown username' do
      let(:url) { 'youtube.com/--not--a--valid--username' }
      it { expect(resource.id).to be_nil }
    end
  end
end