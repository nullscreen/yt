require 'spec_helper'
require 'yt/models/content_owner'

describe Yt::Asset, :partner do
  describe '.ownership' do
    let(:asset) { Yt::Asset.new id: asset_id, auth: $content_owner }
    describe 'given an asset administered by the content owner' do
      let(:asset_id) { ENV['YT_TEST_PARTNER_ASSET_ID'] }

      specify 'the ownership can be obtained' do
        expect(asset.ownership).to be_a Yt::Ownership
      end

      describe 'the asset can be updated' do
        let(:attrs) { {metadata_mine: {notes: 'Yt notes'}} }
        it { expect(asset.update attrs).to be true }
      end
    end
  end
end