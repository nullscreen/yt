require 'spec_helper'
require 'yt/models/content_owner'

describe Yt::Claim, :partner do
  describe '.ownership' do
    let(:claim) { Yt::Claim.new id: claim_id, auth: $content_owner }

    describe 'given a claim administered by the content owner' do
      let(:claim_id) { ENV['YT_TEST_PARTNER_CLAIM_ID'] }

      describe 'the claim can be updated' do
        let(:attrs) { {block_outside_ownership: true} }
        it { expect(claim.update attrs).to be true }
      end
    end
  end
end