# encoding: UTF-8

require 'spec_helper'
require 'yt/models/video'

describe Yt::Video, :device_app, :vcr do
  subject(:video) { Yt::Video.new id: id, auth: test_account }

  context 'given someone else’s video' do
    let(:id) { '9bZkp7q19f0' }

    it { expect(video.content_detail).to be_a Yt::ContentDetail }

    it 'returns valid metadata' do
      expect(video.title).to be_a String
      expect(video.description).to be_a String
      expect(video.thumbnail_url).to be_a String
      expect(video.published_at).to be_a Time
      expect(video.privacy_status).to be_a String
      expect(video.tags).to be_an Array
      expect(video.channel_id).to be_a String
      expect(video.channel_title).to be_a String
      expect(video.channel_url).to be_a String
      expect(video.category_id).to be_a String
      expect(video.live_broadcast_content).to be_a String
      expect(video.view_count).to be_an Integer
      expect(video.like_count).to be_an Integer
      # expect(video.dislike_count).to be_an Integer # 2021-12-13 change
      expect(video.favorite_count).to be_an Integer
      expect(video.comment_count).to be_an Integer
      expect(video.duration).to be_an Integer
      expect(video.length).to be_a String
      expect(video.hd?).to be_in [true, false]
      expect(video.stereoscopic?).to be_in [true, false]
      expect(video.captioned?).to be_in [true, false]
      expect(video.licensed?).to be_in [true, false]
      expect(video.deleted?).to be_in [true, false]
      expect(video.failed?).to be_in [true, false]
      expect(video.processed?).to be_in [true, false]
      expect(video.rejected?).to be_in [true, false]
      expect(video.uploading?).to be_in [true, false]
      expect(video.uses_unsupported_codec?).to be_in [true, false]
      expect(video.has_failed_conversion?).to be_in [true, false]
      expect(video.empty?).to be_in [true, false]
      expect(video.invalid?).to be_in [true, false]
      expect(video.too_small?).to be_in [true, false]
      expect(video.aborted?).to be_in [true, false]
      expect(video.claimed?).to be_in [true, false]
      expect(video.infringes_copyright?).to be_in [true, false]
      expect(video.duplicate?).to be_in [true, false]
      expect(video.scheduled_at.class).to be_in [NilClass, Time]
      expect(video.scheduled?).to be_in [true, false]
      expect(video.too_long?).to be_in [true, false]
      expect(video.violates_terms_of_use?).to be_in [true, false]
      expect(video.inappropriate?).to be_in [true, false]
      expect(video.infringes_trademark?).to be_in [true, false]
      expect(video.belongs_to_closed_account?).to be_in [true, false]
      expect(video.belongs_to_suspended_account?).to be_in [true, false]
      expect(video.licensed_as_creative_commons?).to be_in [true, false]
      expect(video.licensed_as_standard_youtube?).to be_in [true, false]
      expect(video.has_public_stats_viewable?).to be_in [true, false]
      expect(video.embeddable?).to be_in [true, false]
      expect(video.actual_start_time).to be_nil
      expect(video.actual_end_time).to be_nil
      expect(video.scheduled_start_time).to be_nil
      expect(video.scheduled_end_time).to be_nil
      expect(video.concurrent_viewers).to be_nil
      expect(video.embed_html).to be_a String
      expect(video.category_title).to be_a String
    end

    it { expect{video.update}.to fail }
    it { expect{video.delete}.to fail.with 'forbidden' }

    context 'that I like' do
      before { video.like }
      it { expect(video).to be_liked }
      it { expect(video.dislike).to be true }
    end

    context 'that I dislike' do
      before { video.dislike }
      it { expect(video).not_to be_liked }
      it { expect(video.like).to be true }
    end

    context 'that I am indifferent to' do
      before { video.unlike }
      it { expect(video).not_to be_liked }
      it { expect(video.like).to be true }
    end
  end

  context 'given someone else’s live video broadcast scheduled in the future' do
    let(:id) { '3mJE9obZgUc' }

    it 'returns valid live streaming details' do
      expect(video.actual_start_time).to be_nil
      expect(video.actual_end_time).to be_nil
      expect(video.scheduled_start_time).to be_a Time
      expect(video.scheduled_end_time).to be_nil
    end
  end

  context 'given someone else’s past live video broadcast' do
    let(:id) { 'hGil507jyoU' }

    it 'returns valid live streaming details' do
      expect(video.actual_start_time).to be_a Time
      expect(video.actual_end_time).to be_a Time
      expect(video.scheduled_start_time).to be_nil
      expect(video.scheduled_end_time).to be_nil
      expect(video.concurrent_viewers).to be_nil
    end
  end

  context 'given an unknown video' do
    let(:id) { 'not-a-video-id' }

    it { expect{video.content_detail}.to raise_error Yt::Errors::NoItems }
    it { expect{video.snippet}.to raise_error Yt::Errors::NoItems }
    it { expect{video.rating}.to raise_error Yt::Errors::NoItems }
    it { expect{video.status}.to raise_error Yt::Errors::NoItems }
    it { expect{video.statistics_set}.to raise_error Yt::Errors::NoItems }
    it { expect{video.file_detail}.to raise_error Yt::Errors::NoItems }
  end

  context 'given one of my own videos that I want to delete' do
    let(:id) { '505qC3W3DrY' }

    it { expect(video.delete).to be true }
  end

  context 'given one of my own videos that I want to update' do
    let(:id) { '505qC3W3DrY' }
    let!(:old_title) { video.title }
    let!(:old_privacy_status) { video.privacy_status }
    let(:update) { video.update attrs }

    context 'given I update the title' do
      # NOTE: The use of UTF-8 characters is to test that we can pass up to
      # 50 characters, independently of their representation
      let(:attrs) { {title: "Yt Example Update Video - ®•♡❥❦❧☙"} }

      specify 'only updates the title' do
        expect(update).to be true
        expect(video.title).not_to eq old_title
        expect(video.privacy_status).to eq old_privacy_status
      end
    end

    context 'given I update the description' do
      let!(:old_description) { video.description }
      let(:attrs) { {description: "Yt Example Description - ®•♡❥❦❧☙"} }

      specify 'only updates the description' do
        expect(update).to be true
        expect(video.description).not_to eq old_description
        expect(video.title).to eq old_title
        expect(video.privacy_status).to eq old_privacy_status
      end
    end

    context 'given I update the tags' do
      let!(:old_tags) { video.tags }
      let(:attrs) { {tags: ["Yt Test Tag"]} }

      specify 'only updates the tag' do
        expect(update).to be true
        expect(video.tags).not_to eq old_tags
        expect(video.title).to eq old_title
        expect(video.privacy_status).to eq old_privacy_status
      end
    end

    context 'given I update the category ID' do
      let!(:old_category_id) { video.category_id }
      let!(:new_category_id) { old_category_id == '22' ? '23' : '22' }

      context 'passing the parameter in underscore syntax' do
        let(:attrs) { {category_id: new_category_id} }

        specify 'only updates the category ID' do
          expect(update).to be true
          expect(video.category_id).not_to eq old_category_id
          expect(video.title).to eq old_title
          expect(video.privacy_status).to eq old_privacy_status
        end
      end

      context 'passing the parameter in camel-case syntax' do
        let(:attrs) { {categoryId: new_category_id} }

        specify 'only updates the category ID' do
          expect(update).to be true
          expect(video.category_id).not_to eq old_category_id
        end
      end
    end

    context 'given I update title, description and/or tags using angle brackets' do
      let(:attrs) { {title: "Example Yt Test < >", description: '< >', tags: ['<tag>']} }

      specify 'updates them replacing angle brackets with similar unicode characters accepted by YouTube' do
        expect(update).to be true
        expect(video.title).to eq 'Example Yt Test ‹ ›'
        expect(video.description).to eq '‹ ›'
        expect(video.tags).to eq ['‹tag›']
      end
    end

    # note: 'scheduled' videos cannot be set to 'unlisted'
    context 'given I update the privacy status' do
      before { video.update publish_at: nil if video.scheduled? }
      let!(:new_privacy_status) { old_privacy_status == 'private' ? 'unlisted' : 'private' }

      context 'passing the parameter in underscore syntax' do
        let(:attrs) { {privacy_status: new_privacy_status} }

        specify 'only updates the privacy status' do
          expect(update).to be true
          expect(video.privacy_status).not_to eq old_privacy_status
          expect(video.title).to eq old_title
        end
      end

      context 'passing the parameter in camel-case syntax' do
        let(:attrs) { {privacyStatus: new_privacy_status} }

        specify 'only updates the privacy status' do
          expect(update).to be true
          expect(video.privacy_status).not_to eq old_privacy_status
          expect(video.title).to eq old_title
        end
      end
    end

    context 'given I update the embeddable status' do
      let!(:old_embeddable) { video.embeddable? }
      let!(:new_embeddable) { !old_embeddable }

      let(:attrs) { {embeddable: new_embeddable} }

      # @see https://developers.google.com/youtube/v3/docs/videos/update
      specify 'does update the embeddable status' do
        expect(update).to be true
        expect(video.embeddable?).to eq new_embeddable
      end
    end

    context 'given I update the public stats viewable setting' do
      let!(:old_public_stats_viewable) { video.has_public_stats_viewable? }
      let!(:new_public_stats_viewable) { !old_public_stats_viewable }

      context 'passing the parameter in underscore syntax' do
        let(:attrs) { {public_stats_viewable: new_public_stats_viewable} }

        specify 'only updates the public stats viewable setting' do
          expect(update).to be true
          expect(video.has_public_stats_viewable?).to eq new_public_stats_viewable
          expect(video.privacy_status).to eq old_privacy_status
          expect(video.title).to eq old_title
        end
      end

      context 'passing the parameter in camel-case syntax' do
        let(:attrs) { {publicStatsViewable: new_public_stats_viewable} }

        specify 'only updates the public stats viewable setting' do
          expect(update).to be true
          expect(video.has_public_stats_viewable?).to eq new_public_stats_viewable
          expect(video.privacy_status).to eq old_privacy_status
          expect(video.title).to eq old_title
        end
      end
    end
  end

  # @note: This test is separated from the block above because YouTube only
  #   returns file details for *some videos*: "The fileDetails object will
  #   only be returned if the processingDetails.fileAvailability property
  #   has a value of 'available'." Therefore, just to test fileDetails, we use a
  #   different video (I couldn't find any video marked as 'available').
  # @see https://developers.google.com/youtube/v3/docs/videos#fileDetails
  # @see https://developers.google.com/youtube/v3/docs/videos#processingDetails.fileDetailsAvailability
  context 'given one of my own videos' do
    let(:id) { test_account.videos.first.id }

    it 'returns valid file details' do
      expect(video.file_name).to be_a String
      expect(video.file_size).to be_nil
      expect(video.file_type).to be_nil
      expect(video.container).to be_nil
    end
  end
end
