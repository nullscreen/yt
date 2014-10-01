require 'spec_helper'
require 'yt/models/match_policy'

describe Yt::MatchPolicy, :partner do
  subject(:match_policy) { Yt::MatchPolicy.new asset_id: asset_id, auth: $content_owner }

  context 'given an asset managed by the authenticated Content Owner' do
    before { Yt::Ownership.new(asset_id: asset_id, auth: $content_owner).obtain! }
    let(:asset_id) { ENV['YT_TEST_PARTNER_ASSET_ID'] }

    describe 'the asset match policy can be updated' do
      let(:policy_id) { ENV['YT_TEST_PARTNER_POLICY_ID'] }

      it { expect(match_policy.update policy_id: policy_id).to be true }
    end
  end
end