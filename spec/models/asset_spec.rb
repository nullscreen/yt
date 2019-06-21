require 'spec_helper'
require 'yt/models/asset'

describe Yt::Asset do
  subject(:asset) { Yt::Asset.new data: data }

  describe '#id' do
    context 'given fetching a asset returns an id' do
      let(:data) { {"id"=>"A123456789012345"} }
      it { expect(asset.id).to eq 'A123456789012345' }
    end
  end

  describe '#type' do
    context 'given fetching a asset returns an type' do
      let(:data) { {"type"=>"web"} }
      it { expect(asset.type).to eq 'web' }
    end
  end

  describe '#ownership_effective' do
    context 'given fetching a asset returns an ownershipEffective' do
      let(:data) {
        {"ownershipEffective"=>{"kind"=>"youtubePartner#rightsOwnership",
        "general"=>[{"ratio"=>100.0, "owner"=>"XOuN81q-MeEUVrsiZeK1lQ", "type"=>"exclude"}]}}
      }
      it { expect(asset.ownership_effective).to be_a Yt::Ownership }
      it { expect(asset.ownership_effective.general_owners.first).to be_a Yt::RightOwner }
      it { expect(asset.ownership_effective.general_owners.first.owner).to eq "XOuN81q-MeEUVrsiZeK1lQ" }
    end
  end
end
