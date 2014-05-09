require 'spec_helper'
require 'yt/models/rating'

describe Yt::Rating do
  subject(:rating) { Yt::Rating.new }

  describe '#update' do
    before { rating.stub(:do_update).and_yield }

    it { expect(rating.update :like).to be_true }
    it { expect{rating.update :like}.to change{rating.rating} }
  end
end