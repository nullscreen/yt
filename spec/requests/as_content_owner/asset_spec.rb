require 'spec_helper'
require 'yt/models/content_owner'

describe Yt::Asset, :partner do
  describe '.ownership' do
    let(:asset) { Yt::Asset.new id: asset_id, auth: $content_owner }
    describe 'given an asset administered by the content owner' do
      let(:asset_id) { ENV['YT_TEST_PARTNER_ASSET_ID'] }
      it { expect(asset.ownership).to be_a Yt::Ownership }
    end
  end
end