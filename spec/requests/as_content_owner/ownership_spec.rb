require 'spec_helper'
require 'yt/models/ownership'

describe Yt::Ownership, :partner do
  subject(:ownership) { Yt::Ownership.new asset_id: asset_id, auth: $content_owner }

  context 'given an asset managed by the authenticated Content Owner' do
    let(:asset_id) { ENV['YT_TEST_PARTNER_ASSET_ID'] }

    describe 'the ownership can be updated' do
      let(:general_owner) { {ratio: 100, owner: 'FullScreen', type: 'include', territories: ['US', 'CA']} }
      it { expect(ownership.update general: [general_owner]).to be true }
    end

    describe 'the complete ownership can be obtained' do
      before { ownership.release! }
      it { expect(ownership.obtain!).to be true }
    end

    describe 'the complete ownership can be released' do
      after { ownership.obtain! }
      it { expect(ownership.release!).to be true }
    end
  end
end