require 'spec_helper'
require 'yt/errors/unauthorized'

describe Yt::Errors::Unauthorized do
  let(:msg) { %r{^A request to YouTube API was sent without a valid authentication} }

  describe '#exception' do
    it { expect{raise Yt::Errors::Unauthorized}.to raise_error msg }
  end
end