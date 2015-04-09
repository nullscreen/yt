require 'spec_helper'
require 'yt/models/claim'
require 'yt/models/claim_history'

describe Yt::ClaimHistory, :partner do
  subject(:claim) { Yt::Claim.new id: asset_id, auth: $content_owner }

  context 'given a claim previously administered by the authenticated Content Owner' do
    let(:asset_id) { ENV['YT_TEST_CLAIM_ID'] }

    describe 'the claim history can be obtained' do
      it { expect(claim.claim_history.events.size > 0).to eq true }
    end

    describe 'the claim_create event' do
      let(:claim_create_event) { claim.claim_history.events.find {|e| e.type == 'claim_create'} }
      it { expect(claim_create_event.time).to be_a Time }
    end
  end
end