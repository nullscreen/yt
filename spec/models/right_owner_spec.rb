require 'spec_helper'
require 'yt/models/right_owner'

describe Yt::RightOwner do
  subject(:right_owner) { Yt::RightOwner.new data: data }
  let(:data) { {} }

  describe '#ratio' do
    context 'given fetching an owner returns a ratio' do
      let(:data) { {"ratio"=>"20.0"} }
      it { expect(right_owner.ratio).to eq 20 }
    end
  end

  describe '#owner' do
    context 'given fetching an owner returns an owner name' do
      let(:data) { {"owner"=>"FullScreen"} }
      it { expect(right_owner.owner).to eq 'FullScreen' }
    end
  end

  describe '#owner' do
    context 'given fetching an owner returns a publisher name' do
      let(:data) { {"publisher"=>"Third Party"} }
      it { expect(right_owner.publisher).to eq 'Third Party' }
    end

    context 'given fetching an owner does not return a publisher name' do
      it { expect(right_owner.publisher).to be_nil }
    end
  end

  describe '#included_territories' do
    context 'given fetching an owner returns included territories' do
      let(:data) { {"type"=>"include", "territories"=>["US", "CA"]} }
      it { expect(right_owner.included_territories).to eq %w(US CA) }
    end

    context 'given fetching an owner does not return included territories' do
      it { expect(right_owner.included_territories).to be_nil }
    end
  end

  describe '#excluded_territories' do
    context 'given fetching an owner returns excluded territories' do
      let(:data) { {"type"=>"exclude", "territories"=>["US", "CA"]} }
      it { expect(right_owner.excluded_territories).to eq %w(US CA) }
    end

    context 'given fetching an owner does not return excluded territories' do
      it { expect(right_owner.excluded_territories).to be_nil }
    end
  end

  describe '#everywhere?' do
    context 'given fetching an owner returns zero excluded territories' do
      let(:data) { {"type"=>"exclude", "territories"=>[]} }
      it { expect(right_owner).to be_everywhere }
    end

    context 'given fetching an owner returns no excluded territories' do
      let(:data) { {"type"=>"exclude"} }
      it { expect(right_owner).to be_everywhere }
    end

    context 'given fetching an owner returns included territories' do
      let(:data) { {"type"=>"include", "territories"=>[]} }
      it { expect(right_owner).not_to be_everywhere }
    end
  end
end