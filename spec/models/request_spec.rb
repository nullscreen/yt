require 'spec_helper'
require 'yt/models/request'


describe Yt::Request do
  subject(:request) { Yt::Request.new host: 'example.com' }
  let(:response) { response_class.new nil, nil, nil }
  let(:response_body) { }
  before { allow(response).to receive(:body).and_return response_body }
  before { expect(Net::HTTP).to receive(:start).once.and_return response }

  describe '#run' do
    context 'given a request that returns' do
      context 'a success code 2XX' do
        let(:response_class) { Net::HTTPOK }

        it { expect{request.run}.not_to fail }
      end

      context 'an error code 5XX' do
        let(:response_class) { Net::HTTPServerError }
        let(:retry_response) { retry_response_class.new nil, nil, nil }
        before { allow(retry_response).to receive(:body) }
        before { expect(Net::HTTP).to receive(:start).at_least(:once).and_return retry_response }

        context 'every time' do
          let(:retry_response_class) { Net::HTTPServerError }

          it { expect{request.run}.to fail }
        end

        context 'but returns a success code 2XX the second time' do
          let(:retry_response_class) { Net::HTTPOK }

          it { expect{request.run}.not_to fail }
        end
      end

      context 'an error code 400 with "Invalid Query" message' do
        let(:response_class) { Net::HTTPBadRequest }
        let(:response_body) { {error: {errors: [message: message]}}.to_json }
        let(:message) { 'Invalid query. Query did not conform to the expectations' }

        let(:retry_response) { retry_response_class.new nil, nil, nil }
        before { allow(retry_response).to receive(:body) }
        before { expect(Net::HTTP).to receive(:start).at_least(:once).and_return retry_response }

        context 'every time' do
          let(:retry_response_class) { Net::HTTPBadRequest }

          it { expect{request.run}.to fail }
        end

        context 'but returns a success code 2XX the second time' do
          let(:retry_response_class) { Net::HTTPOK }

          it { expect{request.run}.not_to fail }
        end
      end

      context 'an error code 401' do
        let(:response_class) { Net::HTTPUnauthorized }

        it { expect{request.run}.to fail }
      end

      context 'any other non-2XX error code' do
        let(:response_class) { Net::HTTPNotFound }

        it { expect{request.run}.to fail }
      end
    end
  end
end