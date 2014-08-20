require 'spec_helper'
require 'yt/models/advertising_options_set'

describe Yt::AdvertisingOptionsSet, :partner do
  subject(:advertising_options_set) { Yt::AdvertisingOptionsSet.new video_id: video_id, auth: $content_owner }

  context 'given a video managed by the authenticated Content Owner' do
    let(:video_id) { ENV['YT_TEST_PARTNER_CLAIMABLE_VIDEO_ID'] }

    describe 'the advertising options can be updated' do
      let(:params) { {ad_formats: %w(standard_instream long)} }
      it { expect(advertising_options_set.update params).to be true }
    end
  end
end