require 'spec_helper'
require 'yt/models/status'

describe Yt::Status do
  subject(:status) { Yt::Status.new data: data }

  describe '#public?' do
    context 'given fetching a status returns privacyStatus "public"' do
      let(:data) { {"privacyStatus"=>"public"} }
      it { expect(status).to be_public }
    end

    context 'given fetching a status does not returns privacyStatus "public"' do
      let(:data) { {} }
      it { expect(status).not_to be_public }
    end
  end

  describe '#private?' do
    context 'given fetching a status returns privacyStatus "private"' do
      let(:data) { {"privacyStatus"=>"private"} }
      it { expect(status).to be_private }
    end

    context 'given fetching a status does not returns privacyStatus "private"' do
      let(:data) { {} }
      it { expect(status).not_to be_private }
    end
  end

  describe '#unlisted?' do
    context 'given fetching a status returns privacyStatus "unlisted"' do
      let(:data) { {"privacyStatus"=>"unlisted"} }
      it { expect(status).to be_unlisted }
    end

    context 'given fetching a status does not returns privacyStatus "unlisted"' do
      let(:data) { {} }
      it { expect(status).not_to be_unlisted }
    end
  end
end
