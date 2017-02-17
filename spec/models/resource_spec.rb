require 'spec_helper'
require 'yt/models/resource'

describe Yt::Resource do
  subject(:resource) { Yt::Resource.new attrs }

  describe '#public?' do
    context 'given fetching a status returns privacyStatus "public"' do
      let(:attrs) { {status: {"privacyStatus"=>"public"}} }
      it { expect(resource).to be_public }
    end

    context 'given fetching a status does not return privacyStatus "public"' do
      let(:attrs) { {status: {}} }
      it { expect(resource).not_to be_public }
    end
  end

  describe '#private?' do
    context 'given fetching a status returns privacyStatus "private"' do
      let(:attrs) { {status: {"privacyStatus"=>"private"}} }
      it { expect(resource).to be_private }
    end

    context 'given fetching a status does not return privacyStatus "private"' do
      let(:attrs) { {status: {}} }
      it { expect(resource).not_to be_private }
    end
  end

  describe '#unlisted?' do
    context 'given fetching a status returns privacyStatus "unlisted"' do
      let(:attrs) { {status: {"privacyStatus"=>"unlisted"}} }
      it { expect(resource).to be_unlisted }
    end

    context 'given fetching a status does not return privacyStatus "unlisted"' do
      let(:attrs) { {status: {}} }
      it { expect(resource).not_to be_unlisted }
    end
  end
end