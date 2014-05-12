require 'spec_helper'
require 'yt/models/details_set'

describe Yt::DetailsSet do
  subject(:details_set) { Yt::DetailsSet.new data: data }

  describe '#duration' do
    context 'given a details_set with duration in hours, minutes, seconds' do
      let(:data) { {"duration"=>"PT1H18M52S"} }
      it { expect(details_set.duration).to eq 4732 }
    end

    context 'given a details_set with duration in minutes and seconds' do
      let(:data) { {"duration"=>"PT2M51S"} }
      it { expect(details_set.duration).to eq 171 }
    end

    context 'given a details_set with duration in minutes' do
      let(:data) { {"duration"=>"PT2M"} }
      it { expect(details_set.duration).to eq 120 }
    end

    context 'given a details_set with duration in seconds' do
      let(:data) { {"duration"=>"PT51S"} }
      it { expect(details_set.duration).to eq 51 }
    end
  end
end