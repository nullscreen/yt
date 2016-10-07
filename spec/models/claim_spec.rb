require 'spec_helper'
require 'yt/models/claim'

describe Yt::Claim do
  subject(:claim) { Yt::Claim.new data: data }

  describe '#id' do
    context 'given fetching a claim returns an id' do
      let(:data) { {"id"=>"aBcD1EfGHIk"} }
      it { expect(claim.id).to eq 'aBcD1EfGHIk' }
    end
  end

  describe '#asset_id' do
    context 'given fetching a claim returns an assetId' do
      let(:data) { {"assetId"=>"A123456789012601"} }
      it { expect(claim.asset_id).to eq 'A123456789012601' }
    end
  end

  describe '#video_id' do
    context 'given fetching a claim returns an videoId' do
      let(:data) { {"videoId"=>"9bZkp7q19f0"} }
      it { expect(claim.video_id).to eq '9bZkp7q19f0' }
    end
  end

  describe '#status' do
    context 'given fetching a claim returns a status' do
      let(:data) { {"status"=>"active"} }
      it { expect(claim.status).to eq 'active' }
    end
  end

  describe '#active?' do
    context 'given fetching a claim returns an active status' do
      let(:data) { {"status"=>"active"} }
      it { expect(claim).to be_active }
    end

    context 'given fetching a claim does not return an active status' do
      let(:data) { {"status"=>"unknown"} }
      it { expect(claim).not_to be_active }
    end
  end

  describe '#appealed?' do
    context 'given fetching a claim returns an appealed status' do
      let(:data) { {"status"=>"appealed"} }
      it { expect(claim).to be_appealed }
    end

    context 'given fetching a claim does not return an appealed status' do
      let(:data) { {"status"=>"unknown"} }
      it { expect(claim).not_to be_appealed }
    end
  end

  describe '#disputed?' do
    context 'given fetching a claim returns an disputed status' do
      let(:data) { {"status"=>"disputed"} }
      it { expect(claim).to be_disputed }
    end

    context 'given fetching a claim does not return an disputed status' do
      let(:data) { {"status"=>"unknown"} }
      it { expect(claim).not_to be_disputed }
    end
  end

  describe '#inactive?' do
    context 'given fetching a claim returns an inactive status' do
      let(:data) { {"status"=>"inactive"} }
      it { expect(claim).to be_inactive }
    end

    context 'given fetching a claim does not return an inactive status' do
      let(:data) { {"status"=>"unknown"} }
      it { expect(claim).not_to be_inactive }
    end
  end

  describe '#pending?' do
    context 'given fetching a claim returns an pending status' do
      let(:data) { {"status"=>"pending"} }
      it { expect(claim).to be_pending }
    end

    context 'given fetching a claim does not return an pending status' do
      let(:data) { {"status"=>"unknown"} }
      it { expect(claim).not_to be_pending }
    end
  end

  describe '#potential?' do
    context 'given fetching a claim returns an potential status' do
      let(:data) { {"status"=>"potential"} }
      it { expect(claim).to be_potential }
    end

    context 'given fetching a claim does not return an potential status' do
      let(:data) { {"status"=>"unknown"} }
      it { expect(claim).not_to be_potential }
    end
  end

  describe '#takedown?' do
    context 'given fetching a claim returns an takedown status' do
      let(:data) { {"status"=>"takedown"} }
      it { expect(claim).to be_takedown }
    end

    context 'given fetching a claim does not return an takedown status' do
      let(:data) { {"status"=>"unknown"} }
      it { expect(claim).not_to be_takedown }
    end
  end

  describe '#has_unknown_status?' do
    context 'given fetching a claim returns an unknown status' do
      let(:data) { {"status"=>"unknown"} }
      it { expect(claim).to have_unknown_status }
    end

    context 'given fetching a claim does not return an unknown status' do
      let(:data) { {"status"=>"active"} }
      it { expect(claim).not_to have_unknown_status }
    end
  end

  describe '#content_type' do
    context 'given fetching a claim returns a content type' do
      let(:data) { {"contentType"=>"audio"} }
      it { expect(claim.content_type).to eq 'audio' }
    end
  end

  describe '#audio?' do
    context 'given fetching a claim returns an audio content type' do
      let(:data) { {"contentType"=>"audio"} }
      it { expect(claim).to be_audio }
    end

    context 'given fetching a claim does not return an audio content type' do
      let(:data) { {"contentType"=>"audiovisual"} }
      it { expect(claim).not_to be_audio }
    end
  end

  describe '#video?' do
    context 'given fetching a claim returns an video content type' do
      let(:data) { {"contentType"=>"video"} }
      it { expect(claim).to be_video }
    end

    context 'given fetching a claim does not return an video content type' do
      let(:data) { {"contentType"=>"audiovisual"} }
      it { expect(claim).not_to be_video }
    end
  end

  describe '#audiovisual?' do
    context 'given fetching a claim returns an audiovisual content type' do
      let(:data) { {"contentType"=>"audiovisual"} }
      it { expect(claim).to be_audiovisual }
    end

    context 'given fetching a claim does not return an audiovisual content type' do
      let(:data) { {"contentType"=>"audio"} }
      it { expect(claim).not_to be_audiovisual }
    end
  end

  describe '#created_at' do
    context 'given fetching a claim returns a creation timestamp' do
      let(:data) { {"timeCreated"=>"2014-04-22T19:14:49.000Z"} }
      it { expect(claim.created_at.year).to be 2014 }
    end
  end

  describe '#block_outside_ownership?' do
    context 'given fetching a claim returns blockOutsideOwnership true' do
      let(:data) { {"blockOutsideOwnership"=>true} }
      it { expect(claim.block_outside_ownership?).to be true }
    end

    context 'given fetching a claim returns blockOutsideOwnership false' do
      let(:data) { {"blockOutsideOwnership"=>false} }
      it { expect(claim.block_outside_ownership?).to be false }
    end
  end

  describe '#match_reference_id' do
    context 'given fetching a claim returns matchInfo' do
      let(:data) { {"matchInfo"=>{"referenceId"=>"0r3JDtcRLuQ"}} }
      it { expect(claim.match_reference_id).to eq "0r3JDtcRLuQ" }
    end
  end

  describe '#third_party?' do
    context 'given fetching a claim returns thirdPartyClaim true' do
      let(:data) { {"thirdPartyClaim"=>true} }
      it { expect(claim.third_party?).to be true }
    end

    context 'given fetching a claim returns thirdPartyClaim true' do
      let(:data) { {"thirdPartyClaim"=>false} }
      it { expect(claim.third_party?).to be false }
    end
  end

  describe '#source' do
    context 'given fetching a claim returns a source' do
      let(:data) { {"origin"=>{"source"=>"webUpload"}} }
      it { expect(claim.source).to eq 'webUpload' }
    end

    context 'given fetching a claim does not return a source' do
      let(:data) { {"origin"=>{}} }
      it { expect(claim.source).to eq nil }
    end
  end
end
