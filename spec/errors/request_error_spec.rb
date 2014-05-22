require 'spec_helper'
require 'yt/errors/request_error'

describe Yt::Errors::RequestError do
  let(:msg) { %r{^A request to YouTube API failed} }

  describe '#exception' do
    it { expect{raise Yt::Errors::RequestError}.to raise_error msg }
  end
end

describe Yt::Error do
  let(:msg) { %r{^A request to YouTube API failed} }

  describe '#exception' do
    it { expect{raise Yt::Error}.to raise_error msg }
  end
end