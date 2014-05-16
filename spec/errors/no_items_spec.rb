require 'spec_helper'
require 'yt/errors/no_items'

describe Yt::Errors::NoItems do
  let(:msg) { %r{request.+?returned no items} }
  describe '#exception' do
    it { expect{raise Yt::Errors::NoItems}.to raise_error msg }
  end
end