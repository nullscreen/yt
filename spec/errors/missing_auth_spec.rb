require 'spec_helper'
require 'yt/errors/missing_auth'

describe Yt::Errors::MissingAuth do
  let(:msg) { %r{^A request to YouTube API was sent without a valid authentication} }

  describe '#exception' do
    it { expect{raise Yt::Errors::MissingAuth}.to raise_error msg }
  end
end