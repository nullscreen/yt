require 'spec_helper'
require 'yt/errors/forbidden'

describe Yt::Errors::Forbidden do
  let(:msg) { %r{^A request to YouTube API was considered forbidden by the server} }

  describe '#exception' do
    it { expect{raise Yt::Errors::Forbidden}.to raise_error msg }
  end
end