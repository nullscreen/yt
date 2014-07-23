require 'spec_helper'
require 'yt/models/content_owner'

describe Yt::ContentOwner, :partner do
  describe '.partnered_channels' do
    # NOTE: Uncomment once size does not runs through *all* the pages
    # it { expect($content_owner.partnered_channels.size).to be > 0 }
    it { expect($content_owner.partnered_channels.first).to be_a Yt::Channel }
  end

  describe '.claims' do
    it { expect($content_owner.claims.first).to be_a Yt::Claim }

    describe '.where(id: claim_id)' do
      let(:count) { $content_owner.claims.where(id: claim_id).count }

      context 'given the ID of a claim administered by the content owner' do
        let(:claim_id) { ENV['YT_TEST_PARTNER_CLAIM_ID'] }
        it { expect(count).to be > 0 }
      end

      context 'given an unknown claim ID' do
        let(:claim_id) { '--not-a-matching-claim-id--' }
        it { expect(count).to be_zero }
      end
    end

    describe '.where(asset_id: asset_id)' do
      let(:count) { $content_owner.claims.where(asset_id: asset_id).count }

      context 'given the asset ID of a claim administered by the content owner' do
        let(:asset_id) { ENV['YT_TEST_PARTNER_ASSET_ID'] }
        it { expect(count).to be > 0 }
      end

      context 'given an unknown asset ID' do
        let(:asset_id) { 'A123456789012345' }
        it { expect(count).to be_zero }
      end
    end

    describe '.where(video_id: video_id)' do
      let(:count) { $content_owner.claims.where(video_id: video_id).count }

      context 'given the video ID of a claim administered by the content owner' do
        let(:video_id) { ENV['YT_TEST_PARTNER_VIDEO_ID'] }
        it { expect(count).to be > 0 }
      end

      context 'given an unknown video ID' do
        let(:video_id) { '--not-a-matching-video-id--' }
        it { expect(count).to be_zero }
      end
    end

    describe '.where(q: query)' do
      let(:first) { $content_owner.claims.where(params).first }

      context 'given a query matching the title of a video of a claim administered by the content owner' do
        let(:query) { ENV['YT_TEST_PARTNER_Q'] }

        context 'given no optional filters' do
          let(:params) { {q: query} }
          it { expect(first).to be }
        end

        context 'given an optional filter that does not include that video' do
          let(:remote_date) { '2008-01-01T00:00:00.000Z' }

          describe 'applies the filter if the filter name is under_scored' do
            let(:params) { {q: query, created_before: remote_date} }
            it { expect(first).not_to be }
          end

          describe 'applies the filter if the filter name is camelCased' do
            let(:params) { {q: query, createdBefore: remote_date} }
            it { expect(first).not_to be }
          end
        end
      end

      context 'given an unknown video ID' do
        let(:params) { {q: '--not-a-matching-query--'} }
        it { expect(first).not_to be }
      end
    end
  end
end