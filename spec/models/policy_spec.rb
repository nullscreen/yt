require 'spec_helper'
require 'yt/models/policy'

describe Yt::Policy do
  subject(:policy) { Yt::Policy.new data: data }

  describe '#id' do
    context 'given fetching a policy returns an id' do
      let(:data) { {"id"=>"S123456789"} }
      it { expect(policy.id).to eq 'S123456789' }
    end
  end

  describe '#name' do
    context 'given fetching a policy returns a name' do
      let(:data) { {"name"=>"Block in all countries"} }
      it { expect(policy.name).to eq 'Block in all countries' }
    end
  end

  describe '#description' do
    context 'given fetching a policy returns a description' do
      let(:data) { {"description"=>"Block videos in every country"} }
      it { expect(policy.description).to eq 'Block videos in every country' }
    end
  end

  describe '#updated_at' do
    context 'given fetching a policy returns a timeUpdated' do
      let(:data) { {"timeUpdated"=>"1970-01-16T20:33:03.675Z"} }
      it { expect(policy.updated_at.year).to be 1970 }
    end
  end

  describe '#rules' do
    context 'given fetching a policy returns rules' do
      let(:data) { {"rules"=>[{"action"=>"track"},{"action"=>"track"}]} }
      it { expect(policy.rules.size).to be 2 }
    end
  end
end