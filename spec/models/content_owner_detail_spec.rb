require 'spec_helper'
require 'yt/models/content_owner_detail'

describe Yt::ContentOwnerDetail do
  subject(:content_owner_detail) { Yt::ContentOwnerDetail.new data: data }

  describe '#content_owner' do
    context 'given a content_owner_detail with a content owner' do
      let(:data) { {"contentOwner"=>"FullScreen"} }
      it { expect(content_owner_detail.content_owner).to eq 'FullScreen' }
    end

    context 'given a content_owner_detail without a content owner' do
      let(:data) { {} }
      it { expect(content_owner_detail.content_owner).to be_nil }
    end
  end

  describe '#linked_at' do
    context 'given a content_owner_detail with a timeLinked' do
      let(:data) { {"timeLinked"=>"2014-04-22T19:14:49.000Z"} }
      it { expect(content_owner_detail.linked_at.year).to be 2014 }
    end

    context 'given a content_owner_detail with a timeLinked' do
      let(:data) { {} }
      it { expect(content_owner_detail.linked_at).to be_nil }
    end
  end
end