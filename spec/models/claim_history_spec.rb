require 'spec_helper'
require 'yt/models/claim_history'

describe Yt::ClaimHistory do
  subject(:claim_history) { Yt::ClaimHistory.new data: data }

  describe '#id' do
    context 'given fetching claim_history with an id' do
      let(:data) { {"id"=>"acbd1234"}}
      it { expect(claim_history.id).to eq "acbd1234" }
    end
  end

  describe '#uploader_channel_id' do
    context 'given fetching claim_history with an uploader_channel_id' do
      let(:data) { {"uploaderChannelId"=>"C1234"}}
      it { expect(claim_history.uploader_channel_id).to eq "C1234" }
    end
  end

  describe '#events' do
    context 'given fetching claim_history with associated events' do
      let(:data) { {"event"=>[{"time"=>"2015-03-21T21:35:42.000Z"},{"time"=>"2015-03-21T21:35:42.000Z"}]} }
      it { expect(claim_history.events.size).to eq 2 }
    end
  end
end