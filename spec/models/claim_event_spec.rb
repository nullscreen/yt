require 'spec_helper'
require 'yt/models/claim_event'

describe Yt::ClaimEvent do
  subject(:claim_event) { Yt::ClaimEvent.new data: data }

  describe '#time' do
    context 'given fetching a claim_event returns a time' do
      let(:data) { {"time"=>"2015-04-08T21:52:13.000Z"} }
      it { expect(claim_event.time).to be_a Time }
    end
  end

  describe '#type' do
    context 'given fetching a claim_event returns a type' do
      let(:data) { {"type"=>"claim_create"} }
      it { expect(claim_event.type).to eq 'claim_create' }
    end
  end

  describe '#source_type' do
    context 'given fetching a claim_event returns a source_type' do
      let(:data) { {'source'=>{'type' => 'cms_user'}} }
      it { expect(claim_event.source_type).to eq 'cms_user' }
    end
  end

  describe '#source_content_owner_id' do
    context 'given fetching a claim_event returns a source_content_owner_id' do
      let(:data) { {'source'=>{'contentOwnerId' => 'C1234'}} }
      it { expect(claim_event.source_content_owner_id).to eq 'C1234' }
    end
  end

  describe '#source_user_email' do
    context 'given fetching a claim_event returns a source_user_email' do
      let(:data) { {'source'=>{'userEmail' => 'email@fullscreen.net'}} }
      it { expect(claim_event.source_user_email).to eq 'email@fullscreen.net' }
    end
  end

  describe '#dispute_reason' do
    context 'given fetching a claim_event returns a dispute_reason' do
      let(:data) { {'typeDetails'=>{'disputeReason' => 'fair_use'}} }
      it { expect(claim_event.dispute_reason).to eq 'fair_use' }
    end
  end

  describe '#dispute_notes' do
    context 'given fetching a claim_event returns dispute_notes' do
      let(:data) { {'typeDetails'=>{'disputeNotes' => 'User entered notes here.'}} }
      it { expect(claim_event.dispute_notes).to eq 'User entered notes here.' }
    end
  end

  describe '#update_status' do
    context 'given fetching a claim_event returns an update_status' do
      let(:data) { {'typeDetails'=>{'updateStatus' => 'active'}} }
      it { expect(claim_event.update_status).to eq 'active' }
    end
  end
end
