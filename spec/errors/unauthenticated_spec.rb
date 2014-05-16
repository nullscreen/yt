require 'spec_helper'
require 'yt/errors/unauthenticated'

describe Yt::Errors::Unauthenticated do
  let(:msg) { %r{request.+?without the required authentication} }
  describe '#exception' do
    it { expect{raise Yt::Errors::Unauthenticated}.to raise_error msg }
  end
end