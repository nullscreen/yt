require 'spec_helper'
require 'yt/models/reference'

describe Yt::Reference do
  subject(:reference) { Yt::Reference.new data: data }

  describe '#id' do
    context 'given fetching a reference returns an id' do
      let(:data) { {"id"=>"aBcD1EfGHIk"} }
      it { expect(reference.id).to eq 'aBcD1EfGHIk' }
    end
  end

  describe '#asset_id' do
    context 'given fetching a reference returns an assetId' do
      let(:data) { {"assetId"=>"A123456789012601"} }
      it { expect(reference.asset_id).to eq 'A123456789012601' }
    end
  end

  describe '#status' do
    context 'given fetching a reference returns a status' do
      let(:data) { {"status"=>"active"} }
      it { expect(reference.status).to eq 'active' }
    end
  end

  describe '#activating?' do
    context 'given fetching a reference returns an activating status' do
      let(:data) { {"status"=>"activating"} }
      it { expect(reference).to be_activating }
    end

    context 'given fetching a reference does not return an activating status' do
      let(:data) { {"status"=>"unknown"} }
      it { expect(reference).not_to be_activating }
    end
  end

  describe '#active?' do
    context 'given fetching a reference returns an active status' do
      let(:data) { {"status"=>"active"} }
      it { expect(reference).to be_active }
    end

    context 'given fetching a reference does not return an active status' do
      let(:data) { {"status"=>"unknown"} }
      it { expect(reference).not_to be_active }
    end
  end

  describe '#checking?' do
    context 'given fetching a reference returns an checking status' do
      let(:data) { {"status"=>"checking"} }
      it { expect(reference).to be_checking }
    end

    context 'given fetching a reference does not return an checking status' do
      let(:data) { {"status"=>"unknown"} }
      it { expect(reference).not_to be_checking }
    end
  end

  describe '#computing_fingerprint?' do
    context 'given fetching a reference returns an computing_fingerprint status' do
      let(:data) { {"status"=>"computing_fingerprint"} }
      it { expect(reference).to be_computing_fingerprint }
    end

    context 'given fetching a reference does not return an computing_fingerprint status' do
      let(:data) { {"status"=>"unknown"} }
      it { expect(reference).not_to be_computing_fingerprint }
    end
  end

  describe '#deleted?' do
    context 'given fetching a reference returns an deleted status' do
      let(:data) { {"status"=>"deleted"} }
      it { expect(reference).to be_deleted }
    end

    context 'given fetching a reference does not return an deleted status' do
      let(:data) { {"status"=>"unknown"} }
      it { expect(reference).not_to be_deleted }
    end
  end

  describe '#duplicate_on_hold?' do
    context 'given fetching a reference returns an duplicate_on_hold status' do
      let(:data) { {"status"=>"duplicate_on_hold"} }
      it { expect(reference).to be_duplicate_on_hold }
    end

    context 'given fetching a reference does not return an duplicate_on_hold status' do
      let(:data) { {"status"=>"unknown"} }
      it { expect(reference).not_to be_duplicate_on_hold }
    end
  end

  describe '#inactive?' do
    context 'given fetching a reference returns an inactive status' do
      let(:data) { {"status"=>"inactive"} }
      it { expect(reference).to be_inactive }
    end

    context 'given fetching a reference does not return an inactive status' do
      let(:data) { {"status"=>"unknown"} }
      it { expect(reference).not_to be_inactive }
    end
  end

  describe '#live_streaming_processing?' do
    context 'given fetching a reference returns an live_streaming_processing status' do
      let(:data) { {"status"=>"live_streaming_processing"} }
      it { expect(reference).to be_live_streaming_processing }
    end

    context 'given fetching a reference does not return an live_streaming_processing status' do
      let(:data) { {"status"=>"unknown"} }
      it { expect(reference).not_to be_live_streaming_processing }
    end
  end

  describe '#urgent_reference_processing?' do
    context 'given fetching a reference returns an urgent_reference_processing status' do
      let(:data) { {"status"=>"urgent_reference_processing"} }
      it { expect(reference).to be_urgent_reference_processing }
    end

    context 'given fetching a reference does not return an urgent_reference_processing status' do
      let(:data) { {"status"=>"unknown"} }
      it { expect(reference).not_to be_urgent_reference_processing }
    end
  end

  describe '#status_reason' do
    context 'given fetching a reference returns a statusReason' do
      let(:data) { {"statusReason"=>"explanation"} }
      it { expect(reference.status_reason).to eq 'explanation' }
    end
  end

  describe '#duplicate_leader' do
    context 'given fetching a reference returns a duplicateLeader' do
      let(:data) { {"duplicateLeader"=>"123456"} }
      it { expect(reference.duplicate_leader).to eq '123456' }
    end
  end

  describe '#length' do
    context 'given fetching a reference returns a length' do
      let(:data) { {"length"=>354.66} }
      it { expect(reference.length).to eq 354.66 }
    end
  end

  describe '#video_id' do
    context 'given fetching a reference returns an videoId' do
      let(:data) { {"videoId"=>"9bZkp7q19f0"} }
      it { expect(reference.video_id).to eq '9bZkp7q19f0' }
    end
  end

  describe '#claim_id' do
    context 'given fetching a reference returns an claimId' do
      let(:data) { {"claimId"=>"aBcD1EfGHIk"} }
      it { expect(reference.claim_id).to eq 'aBcD1EfGHIk' }
    end
  end

  describe '#urgent?' do
    context 'given fetching a reference returns an urgent status true' do
      let(:data) { {"urgent"=>true} }
      it { expect(reference).to be_urgent }
    end

    context 'given fetching a reference returns an urgent status false' do
      let(:data) { {"urgent"=>false} }
      it { expect(reference).not_to be_urgent }
    end
  end

  describe '#content_type' do
    context 'given fetching a reference returns a content type' do
      let(:data) { {"contentType"=>"audio"} }
      it { expect(reference.content_type).to eq 'audio' }
    end
  end

  describe '#audio?' do
    context 'given fetching a reference returns an audio content type' do
      let(:data) { {"contentType"=>"audio"} }
      it { expect(reference).to be_audio }
    end

    context 'given fetching a reference does not return an audio content type' do
      let(:data) { {"contentType"=>"audiovisual"} }
      it { expect(reference).not_to be_audio }
    end
  end

  describe '#video?' do
    context 'given fetching a reference returns an video content type' do
      let(:data) { {"contentType"=>"video"} }
      it { expect(reference).to be_video }
    end

    context 'given fetching a reference does not return an video content type' do
      let(:data) { {"contentType"=>"audiovisual"} }
      it { expect(reference).not_to be_video }
    end
  end

  describe '#audiovisual?' do
    context 'given fetching a reference returns an audiovisual content type' do
      let(:data) { {"contentType"=>"audiovisual"} }
      it { expect(reference).to be_audiovisual }
    end

    context 'given fetching a reference does not return an audiovisual content type' do
      let(:data) { {"contentType"=>"audio"} }
      it { expect(reference).not_to be_audiovisual }
    end
  end

  describe '#audioswap_enabled?' do
    context 'given fetching a reference returns audioswapEnabled true' do
      let(:data) { {"audioswapEnabled"=>true} }
      it { expect(reference).to be_audioswap_enabled }
    end

    context 'given fetching a reference returns audioswapEnabled false' do
      let(:data) { {"audioswap_enabled"=>false} }
      it { expect(reference).not_to be_audioswap_enabled }
    end
  end

  describe '#ignore_fp_match?' do
    context 'given fetching a reference returns ignoreFpMatch true' do
      let(:data) { {"ignoreFpMatch"=>true} }
      it { expect(reference.ignore_fp_match?).to be true }
    end

    context 'given fetching a reference returns ignoreFpMatch false' do
      let(:data) { {"ignoreFpMatch"=>false} }
      it { expect(reference.ignore_fp_match?).to be false }
    end
  end
end