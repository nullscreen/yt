require 'spec_helper'
require 'yt/errors/failed'

describe Yt::Errors::Failed do
  let(:msg) { %r{request.+?failed} }
  describe '#exception' do
    it { expect{raise Yt::Errors::Failed}.to raise_error msg }
  end
end