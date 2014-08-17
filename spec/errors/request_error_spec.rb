require 'spec_helper'
require 'yt/errors/request_error'

describe Yt::Errors::RequestError do
  subject(:error) { raise Yt::Errors::RequestError, params }
  let(:params) { {} }
  let(:msg) { %r{^A request to YouTube API failed} }

  describe '#exception' do
    it { expect{error}.to raise_error msg }

    context 'given the exception includes sensitive data' do
      let(:body) { 'some secret token' }
      let(:curl) { 'curl -H "Authorization: secret-token"' }
      let(:params) { {response_body: body, request_curl: curl}.to_json }

      describe 'given a log level of :debug or :devel' do
        before(:all) { Yt.configuration.log_level = :debug }
        specify 'exposes sensitive data' do
          expect{error}.to raise_error do |error|
            expect(error.message).to include 'secret'
          end
        end
      end

      describe 'given a different log level' do
        before(:all) { Yt.configuration.log_level = :info }
        specify 'hides sensitive data' do
          expect{error}.to raise_error do |error|
            expect(error.message).not_to include 'secret'
          end
        end
      end
    end
  end
end

describe Yt::Error do
  let(:msg) { %r{^A request to YouTube API failed} }

  describe '#exception' do
    it { expect{raise Yt::Error}.to raise_error msg }
  end
end