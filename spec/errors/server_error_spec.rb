require 'spec_helper'
require 'yt/errors/server_error'

describe Yt::Errors::ServerError do
  let(:msg) { %r{^A request to YouTube API caused an unexpected server error} }

  describe '#exception' do
    it { expect{raise Yt::Errors::ServerError}.to raise_error msg }
  end
end