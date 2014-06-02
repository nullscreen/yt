require 'spec_helper'
require 'yt/models/request'

describe Yt::Request do
  subject(:request) { Yt::Request.new attrs }
  let(:attrs) { {host: 'example.com'} }
  before { expect(Net::HTTP).to receive(:start).and_return response }
  before { allow(response).to receive(:body) }

  describe '#run' do
    context 'given a request that returns a 500 code' do
      let(:response) { Net::HTTPServerError.new nil, nil, nil }
      it { expect{request.run}.to fail }
    end

    context 'given a request that returns a 401 code' do
      let(:response) { Net::HTTPUnauthorized.new nil, nil, nil }
      it { expect{request.run}.to fail }
    end

    context 'given a request that returns a non-2XX code' do
      let(:response) { Net::HTTPNotFound.new nil, nil, nil }
      it { expect{request.run}.to fail }
    end

    context 'given a request that returns a 2XX code' do
      let(:response) { Net::HTTPOK.new nil, nil, nil }
      it { expect{request.run}.not_to fail }
    end
  end
end