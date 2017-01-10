# encoding: UTF-8

require 'spec_helper'
require 'yt/models/video'

describe Yt::Video, :device_app do
  subject(:video) { Yt::Video.new id: id, auth: $account }

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
      expect(video.dislike_count).to be_an Integer
      expect(video.favorite_count).to be_an Integer
      expect(video.comment_count).to be_an Integer
      expect(video.duration).to be_an Integer
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
    let(:id) { 'PqzGI8gO_gk' }

    it 'returns valid live streaming details' do
      expect(video.actual_start_time).to be_nil
      expect(video.actual_end_time).to be_nil
      expect(video.scheduled_start_time).to be_a Time
      expect(video.scheduled_end_time).to be_nil
    end
  end

  context 'given someone else’s past live video broadcast' do
    let(:id) { 'COOM8_tOy6U' }

    it 'returns valid live streaming details' do
      expect(video.actual_start_time).to be_a Time
      expect(video.actual_end_time).to be_a Time
      expect(video.scheduled_start_time).to be_a Time
      expect(video.scheduled_end_time).to be_a Time
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
    before(:all) { @tmp_video = $account.upload_video 'https://bit.ly/yt_test', title: "Yt Test Delete Video #{rand}" }
    let(:id) { @tmp_video.id }

    it { expect(video.delete).to be true }
  end

  context 'given one of my own videos that I want to update' do
    let(:id) { $account.videos.where(order: 'viewCount').first.id }
    let!(:old_title) { video.title }
    let!(:old_privacy_status) { video.privacy_status }
    let(:update) { video.update attrs }

    context 'given I update the title' do
      # NOTE: The use of UTF-8 characters is to test that we can pass up to
      # 50 characters, independently of their representation
      let(:attrs) { {title: "Yt Example Update Video #{rand} - ®•♡❥❦❧☙"} }

      specify 'only updates the title' do
        expect(update).to be true
        expect(video.title).not_to eq old_title
        expect(video.privacy_status).to eq old_privacy_status
      end
    end

    context 'given I update the description' do
      let!(:old_description) { video.description }
      let(:attrs) { {description: "Yt Example Description  #{rand} - ®•♡❥❦❧☙"} }

      specify 'only updates the description' do
        expect(update).to be true
        expect(video.description).not_to eq old_description
        expect(video.title).to eq old_title
        expect(video.privacy_status).to eq old_privacy_status
      end
    end

    context 'given I update the tags' do
      let!(:old_tags) { video.tags }
      let(:attrs) { {tags: ["Yt Test Tag #{rand}"]} }

      specify 'only updates the tag' do
        expect(update).to be true
        expect(video.tags).not_to eq old_tags
        expect(video.title).to eq old_title
        expect(video.privacy_status).to eq old_privacy_status
      end
    end

    context 'given I update the category ID' do
      let!(:old_category_id) { video.category_id }
      let!(:new_category_id) { old_category_id == '22' ? '21' : '22' }

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

      # @note: This test is a reflection of another irrational behavior of
      #   YouTube API. Although 'embeddable' can be passed as an 'update'
      #   attribute according to the documentation, it simply does not work.
      #   The day YouTube fixes it, then this test will finally fail and will
      #   be removed, documenting how to update 'embeddable' too.
      # @see https://developers.google.com/youtube/v3/docs/videos/update
      # @see https://code.google.com/p/gdata-issues/issues/detail?id=4861
      specify 'does not update the embeddable status' do
        expect(update).to be true
        expect(video.embeddable?).to eq old_embeddable
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

    it 'returns valid reports for video-related metrics' do
      # Some reports are only available to Content Owners.
      # See content owner test for more details about what the methods return.
      expect{video.views}.not_to raise_error
      expect{video.comments}.not_to raise_error
      expect{video.likes}.not_to raise_error
      expect{video.dislikes}.not_to raise_error
      expect{video.shares}.not_to raise_error
      expect{video.subscribers_gained}.not_to raise_error
      expect{video.subscribers_lost}.not_to raise_error
      expect{video.videos_added_to_playlists}.not_to raise_error
      expect{video.videos_removed_from_playlists}.not_to raise_error
      expect{video.estimated_minutes_watched}.not_to raise_error
      expect{video.average_view_duration}.not_to raise_error
      expect{video.average_view_percentage}.not_to raise_error
      expect{video.annotation_clicks}.not_to raise_error
      expect{video.annotation_click_through_rate}.not_to raise_error
      expect{video.annotation_close_rate}.not_to raise_error
      expect{video.card_impressions}.not_to raise_error
      expect{video.card_clicks}.not_to raise_error
      expect{video.card_click_rate}.not_to raise_error
      expect{video.card_teaser_impressions}.not_to raise_error
      expect{video.card_teaser_clicks}.not_to raise_error
      expect{video.card_teaser_click_rate}.not_to raise_error
      expect{video.viewer_percentage}.not_to raise_error
      expect{video.estimated_revenue}.to raise_error Yt::Errors::Unauthorized
      expect{video.ad_impressions}.to raise_error Yt::Errors::Unauthorized
      expect{video.monetized_playbacks}.to raise_error Yt::Errors::Unauthorized
      expect{video.playback_based_cpm}.to raise_error Yt::Errors::Unauthorized
      expect{video.advertising_options_set}.to raise_error Yt::Errors::Forbidden
    end
  end

  # @note: This test is separated from the block above because, for some
  #   undocumented reasons, if an existing video was private, then set to
  #   unlisted, then set to private again, YouTube _sometimes_ raises a
  #   400 Error when trying to set the publishAt timestamp.
  #   Therefore, just to test the updating of publishAt, we use a brand new
  #   video (set to private), rather than reusing an existing one as above.
  context 'given one of my own *private* videos that I want to update' do
    before { @tmp_video = $account.upload_video 'https://bit.ly/yt_test', title: old_title, privacy_status: old_privacy_status }
    let(:id) { @tmp_video.id }
    let!(:old_title) { "Yt Test Update publishAt Video #{rand}" }
    let!(:old_privacy_status) { 'private' }
    after  { video.delete }

    let!(:new_scheduled_at) { Yt::Timestamp.parse("#{rand(30) + 1} Jan 2020", Time.now) }

    context 'passing the parameter in underscore syntax' do
      let(:attrs) { {publish_at: new_scheduled_at} }

      specify 'only updates the timestamp to publish the video' do
        expect(video.update attrs).to be true
        expect(video.privacy_status).to eq old_privacy_status
        expect(video.title).to eq old_title
        # NOTE: This is another irrational behavior of YouTube API. In short,
        # the response of Video#update *does not* include the publishAt value
        # even if it exists. You need to call Video#list again to get it.
        video = Yt::Video.new id: id, auth: $account
        expect(video.scheduled_at).to eq new_scheduled_at
        # Setting a private (scheduled) video to private has no effect:
        expect(video.update privacy_status: 'private').to be true
        video = Yt::Video.new id: id, auth: $account
        expect(video.scheduled_at).to eq new_scheduled_at
        # Setting a private (scheduled) video to unlisted/public removes publishAt:
        expect(video.update privacy_status: 'unlisted').to be true
        video = Yt::Video.new id: id, auth: $account
        expect(video.scheduled_at).to be_nil
      end
    end

    context 'passing the parameter in camel-case syntax' do
      let(:attrs) { {publishAt: new_scheduled_at} }

      specify 'only updates the timestamp to publish the video' do
        expect(video.update attrs).to be true
        expect(video.scheduled_at).to eq new_scheduled_at
        expect(video.privacy_status).to eq old_privacy_status
        expect(video.title).to eq old_title
      end
    end
  end

  # @note: This should somehow test that the thumbnail *changes*. However,
  #   YouTube does not change the URL of the thumbnail even though the content
  #   changes. A full test would have to *download* the thumbnails before and
  #   after, and compare the files. For now, not raising error is enough.
  #   Eventually, change to `expect{update}.to change{video.thumbnail_url}`
  context 'given one of my own videos for which I want to upload a thumbnail' do
    let(:id) { $account.videos.where(order: 'viewCount').first.id }
    let(:update) { video.upload_thumbnail path_or_url }

    context 'given the path to a local JPG image file' do
      let(:path_or_url) { File.expand_path '../thumbnail.jpg', __FILE__ }

      it { expect{update}.not_to raise_error }
    end

    context 'given the path to a remote PNG image file' do
      let(:path_or_url) { 'https://bit.ly/yt_thumbnail' }

      it { expect{update}.not_to raise_error }
    end

    context 'given an invalid URL' do
      let(:path_or_url) { 'this-is-not-a-url' }

      it { expect{update}.to raise_error Yt::Errors::RequestError }
    end
  end

  # @note: This test is separated from the block above because YouTube only
  #   returns file details for *some videos*: "The fileDetails object will
  #   only be returned if the processingDetails.fileAvailability property
  #   has a value of available.". Therefore, just to test fileDetails, we use a
  #   different video that (for some unknown reason) is marked as 'available'.
  #   Also note that I was not able to find a single video returning fileName,
  #   therefore video.file_name is not returned by Yt, until it can be tested.
  # @see https://developers.google.com/youtube/v3/docs/videos#processingDetails.fileDetailsAvailability
  context 'given one of my own *available* videos' do
    let(:id) { 'yCmaOvUFhlI' }

    it 'returns valid file details' do
      expect(video.file_size).to be_an Integer
      expect(video.file_type).to be_a String
      expect(video.container).to be_a String
    end
  end
end
# encoding: UTF-8

require 'spec_helper'
require 'yt/models/video'

describe Yt::Video, :device_app do
  subject(:video) { Yt::Video.new id: id, auth: $account }

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
      expect(video.dislike_count).to be_an Integer
      expect(video.favorite_count).to be_an Integer
      expect(video.comment_count).to be_an Integer
      expect(video.duration).to be_an Integer
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
    let(:id) { 'PqzGI8gO_gk' }

    it 'returns valid live streaming details' do
      expect(video.actual_start_time).to be_nil
      expect(video.actual_end_time).to be_nil
      expect(video.scheduled_start_time).to be_a Time
      expect(video.scheduled_end_time).to be_nil
    end
  end

  context 'given someone else’s past live video broadcast' do
    let(:id) { 'COOM8_tOy6U' }

    it 'returns valid live streaming details' do
      expect(video.actual_start_time).to be_a Time
      expect(video.actual_end_time).to be_a Time
      expect(video.scheduled_start_time).to be_a Time
      expect(video.scheduled_end_time).to be_a Time
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
    before(:all) { @tmp_video = $account.upload_video 'https://bit.ly/yt_test', title: "Yt Test Delete Video #{rand}" }
    let(:id) { @tmp_video.id }

    it { expect(video.delete).to be true }
  end

  context 'given one of my own videos that I want to update' do
    let(:id) { $account.videos.where(order: 'viewCount').first.id }
    let!(:old_title) { video.title }
    let!(:old_privacy_status) { video.privacy_status }
    let(:update) { video.update attrs }

    context 'given I update the title' do
      # NOTE: The use of UTF-8 characters is to test that we can pass up to
      # 50 characters, independently of their representation
      let(:attrs) { {title: "Yt Example Update Video #{rand} - ®•♡❥❦❧☙"} }

      specify 'only updates the title' do
        expect(update).to be true
        expect(video.title).not_to eq old_title
        expect(video.privacy_status).to eq old_privacy_status
      end
    end

    context 'given I update the description' do
      let!(:old_description) { video.description }
      let(:attrs) { {description: "Yt Example Description  #{rand} - ®•♡❥❦❧☙"} }

      specify 'only updates the description' do
        expect(update).to be true
        expect(video.description).not_to eq old_description
        expect(video.title).to eq old_title
        expect(video.privacy_status).to eq old_privacy_status
      end
    end

    context 'given I update the tags' do
      let!(:old_tags) { video.tags }
      let(:attrs) { {tags: ["Yt Test Tag #{rand}"]} }

      specify 'only updates the tag' do
        expect(update).to be true
        expect(video.tags).not_to eq old_tags
        expect(video.title).to eq old_title
        expect(video.privacy_status).to eq old_privacy_status
      end
    end

    context 'given I update the category ID' do
      let!(:old_category_id) { video.category_id }
      let!(:new_category_id) { old_category_id == '22' ? '21' : '22' }

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

      # @note: This test is a reflection of another irrational behavior of
      #   YouTube API. Although 'embeddable' can be passed as an 'update'
      #   attribute according to the documentation, it simply does not work.
      #   The day YouTube fixes it, then this test will finally fail and will
      #   be removed, documenting how to update 'embeddable' too.
      # @see https://developers.google.com/youtube/v3/docs/videos/update
      # @see https://code.google.com/p/gdata-issues/issues/detail?id=4861
      specify 'does not update the embeddable status' do
        expect(update).to be true
        expect(video.embeddable?).to eq old_embeddable
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

    it 'returns valid reports for video-related metrics' do
      # Some reports are only available to Content Owners.
      # See content owner test for more details about what the methods return.
      expect{video.views}.not_to raise_error
      expect{video.comments}.not_to raise_error
      expect{video.likes}.not_to raise_error
      expect{video.dislikes}.not_to raise_error
      expect{video.shares}.not_to raise_error
      expect{video.subscribers_gained}.not_to raise_error
      expect{video.subscribers_lost}.not_to raise_error
      expect{video.videos_added_to_playlists}.not_to raise_error
      expect{video.videos_removed_from_playlists}.not_to raise_error
      expect{video.estimated_minutes_watched}.not_to raise_error
      expect{video.average_view_duration}.not_to raise_error
      expect{video.average_view_percentage}.not_to raise_error
      expect{video.annotation_clicks}.not_to raise_error
      expect{video.annotation_click_through_rate}.not_to raise_error
      expect{video.annotation_close_rate}.not_to raise_error
      expect{video.viewer_percentage}.not_to raise_error
      expect{video.estimated_revenue}.to raise_error Yt::Errors::Unauthorized
      expect{video.ad_impressions}.to raise_error Yt::Errors::Unauthorized
      expect{video.monetized_playbacks}.to raise_error Yt::Errors::Unauthorized
      expect{video.playback_based_cpm}.to raise_error Yt::Errors::Unauthorized
      expect{video.advertising_options_set}.to raise_error Yt::Errors::Forbidden
    end
  end

  # @note: This test is separated from the block above because, for some
  #   undocumented reasons, if an existing video was private, then set to
  #   unlisted, then set to private again, YouTube _sometimes_ raises a
  #   400 Error when trying to set the publishAt timestamp.
  #   Therefore, just to test the updating of publishAt, we use a brand new
  #   video (set to private), rather than reusing an existing one as above.
  context 'given one of my own *private* videos that I want to update' do
    before { @tmp_video = $account.upload_video 'https://bit.ly/yt_test', title: old_title, privacy_status: old_privacy_status }
    let(:id) { @tmp_video.id }
    let!(:old_title) { "Yt Test Update publishAt Video #{rand}" }
    let!(:old_privacy_status) { 'private' }
    after  { video.delete }

    let!(:new_scheduled_at) { Yt::Timestamp.parse("#{rand(30) + 1} Jan 2020", Time.now) }

    context 'passing the parameter in underscore syntax' do
      let(:attrs) { {publish_at: new_scheduled_at} }

      specify 'only updates the timestamp to publish the video' do
        expect(video.update attrs).to be true
        expect(video.privacy_status).to eq old_privacy_status
        expect(video.title).to eq old_title
        # NOTE: This is another irrational behavior of YouTube API. In short,
        # the response of Video#update *does not* include the publishAt value
        # even if it exists. You need to call Video#list again to get it.
        video = Yt::Video.new id: id, auth: $account
        expect(video.scheduled_at).to eq new_scheduled_at
        # Setting a private (scheduled) video to private has no effect:
        expect(video.update privacy_status: 'private').to be true
        video = Yt::Video.new id: id, auth: $account
        expect(video.scheduled_at).to eq new_scheduled_at
        # Setting a private (scheduled) video to unlisted/public removes publishAt:
        expect(video.update privacy_status: 'unlisted').to be true
        video = Yt::Video.new id: id, auth: $account
        expect(video.scheduled_at).to be_nil
      end
    end

    context 'passing the parameter in camel-case syntax' do
      let(:attrs) { {publishAt: new_scheduled_at} }

      specify 'only updates the timestamp to publish the video' do
        expect(video.update attrs).to be true
        expect(video.scheduled_at).to eq new_scheduled_at
        expect(video.privacy_status).to eq old_privacy_status
        expect(video.title).to eq old_title
      end
    end
  end

  # @note: This should somehow test that the thumbnail *changes*. However,
  #   YouTube does not change the URL of the thumbnail even though the content
  #   changes. A full test would have to *download* the thumbnails before and
  #   after, and compare the files. For now, not raising error is enough.
  #   Eventually, change to `expect{update}.to change{video.thumbnail_url}`
  context 'given one of my own videos for which I want to upload a thumbnail' do
    let(:id) { $account.videos.where(order: 'viewCount').first.id }
    let(:update) { video.upload_thumbnail path_or_url }

    context 'given the path to a local JPG image file' do
      let(:path_or_url) { File.expand_path '../thumbnail.jpg', __FILE__ }

      it { expect{update}.not_to raise_error }
    end

    context 'given the path to a remote PNG image file' do
      let(:path_or_url) { 'https://bit.ly/yt_thumbnail' }

      it { expect{update}.not_to raise_error }
    end

    context 'given an invalid URL' do
      let(:path_or_url) { 'this-is-not-a-url' }

      it { expect{update}.to raise_error Yt::Errors::RequestError }
    end
  end

  # @note: This test is separated from the block above because YouTube only
  #   returns file details for *some videos*: "The fileDetails object will
  #   only be returned if the processingDetails.fileAvailability property
  #   has a value of available.". Therefore, just to test fileDetails, we use a
  #   different video that (for some unknown reason) is marked as 'available'.
  #   Also note that I was not able to find a single video returning fileName,
  #   therefore video.file_name is not returned by Yt, until it can be tested.
  # @see https://developers.google.com/youtube/v3/docs/videos#processingDetails.fileDetailsAvailability
  context 'given one of my own *available* videos' do
    let(:id) { 'yCmaOvUFhlI' }

    it 'returns valid file details' do
      expect(video.file_size).to be_an Integer
      expect(video.file_type).to be_a String
      expect(video.container).to be_a String
    end
  end
end
# encoding: UTF-8

require 'spec_helper'
require 'yt/models/video'

describe Yt::Video, :device_app do
  subject(:video) { Yt::Video.new id: id, auth: $account }

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
      expect(video.dislike_count).to be_an Integer
      expect(video.favorite_count).to be_an Integer
      expect(video.comment_count).to be_an Integer
      expect(video.duration).to be_an Integer
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
    let(:id) { 'PqzGI8gO_gk' }

    it 'returns valid live streaming details' do
      expect(video.actual_start_time).to be_nil
      expect(video.actual_end_time).to be_nil
      expect(video.scheduled_start_time).to be_a Time
      expect(video.scheduled_end_time).to be_nil
    end
  end

  context 'given someone else’s past live video broadcast' do
    let(:id) { 'COOM8_tOy6U' }

    it 'returns valid live streaming details' do
      expect(video.actual_start_time).to be_a Time
      expect(video.actual_end_time).to be_a Time
      expect(video.scheduled_start_time).to be_a Time
      expect(video.scheduled_end_time).to be_a Time
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
    before(:all) { @tmp_video = $account.upload_video 'https://bit.ly/yt_test', title: "Yt Test Delete Video #{rand}" }
    let(:id) { @tmp_video.id }

    it { expect(video.delete).to be true }
  end

  context 'given one of my own videos that I want to update' do
    let(:id) { $account.videos.where(order: 'viewCount').first.id }
    let!(:old_title) { video.title }
    let!(:old_privacy_status) { video.privacy_status }
    let(:update) { video.update attrs }

    context 'given I update the title' do
      # NOTE: The use of UTF-8 characters is to test that we can pass up to
      # 50 characters, independently of their representation
      let(:attrs) { {title: "Yt Example Update Video #{rand} - ®•♡❥❦❧☙"} }

      specify 'only updates the title' do
        expect(update).to be true
        expect(video.title).not_to eq old_title
        expect(video.privacy_status).to eq old_privacy_status
      end
    end

    context 'given I update the description' do
      let!(:old_description) { video.description }
      let(:attrs) { {description: "Yt Example Description  #{rand} - ®•♡❥❦❧☙"} }

      specify 'only updates the description' do
        expect(update).to be true
        expect(video.description).not_to eq old_description
        expect(video.title).to eq old_title
        expect(video.privacy_status).to eq old_privacy_status
      end
    end

    context 'given I update the tags' do
      let!(:old_tags) { video.tags }
      let(:attrs) { {tags: ["Yt Test Tag #{rand}"]} }

      specify 'only updates the tag' do
        expect(update).to be true
        expect(video.tags).not_to eq old_tags
        expect(video.title).to eq old_title
        expect(video.privacy_status).to eq old_privacy_status
      end
    end

    context 'given I update the category ID' do
      let!(:old_category_id) { video.category_id }
      let!(:new_category_id) { old_category_id == '22' ? '21' : '22' }

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

    it 'returns valid reports for video-related metrics' do
      # Some reports are only available to Content Owners.
      # See content owner test for more details about what the methods return.
      expect{video.views}.not_to raise_error
      expect{video.comments}.not_to raise_error
      expect{video.likes}.not_to raise_error
      expect{video.dislikes}.not_to raise_error
      expect{video.shares}.not_to raise_error
      expect{video.subscribers_gained}.not_to raise_error
      expect{video.subscribers_lost}.not_to raise_error
      expect{video.videos_added_to_playlists}.not_to raise_error
      expect{video.videos_removed_from_playlists}.not_to raise_error
      expect{video.estimated_minutes_watched}.not_to raise_error
      expect{video.average_view_duration}.not_to raise_error
      expect{video.average_view_percentage}.not_to raise_error
      expect{video.annotation_clicks}.not_to raise_error
      expect{video.annotation_click_through_rate}.not_to raise_error
      expect{video.annotation_close_rate}.not_to raise_error
      expect{video.viewer_percentage}.not_to raise_error
      expect{video.estimated_revenue}.to raise_error Yt::Errors::Unauthorized
      expect{video.ad_impressions}.to raise_error Yt::Errors::Unauthorized
      expect{video.monetized_playbacks}.to raise_error Yt::Errors::Unauthorized
      expect{video.playback_based_cpm}.to raise_error Yt::Errors::Unauthorized
      expect{video.advertising_options_set}.to raise_error Yt::Errors::Forbidden
    end
  end

  # @note: This test is separated from the block above because, for some
  #   undocumented reasons, if an existing video was private, then set to
  #   unlisted, then set to private again, YouTube _sometimes_ raises a
  #   400 Error when trying to set the publishAt timestamp.
  #   Therefore, just to test the updating of publishAt, we use a brand new
  #   video (set to private), rather than reusing an existing one as above.
  context 'given one of my own *private* videos that I want to update' do
    before { @tmp_video = $account.upload_video 'https://bit.ly/yt_test', title: old_title, privacy_status: old_privacy_status }
    let(:id) { @tmp_video.id }
    let!(:old_title) { "Yt Test Update publishAt Video #{rand}" }
    let!(:old_privacy_status) { 'private' }
    after  { video.delete }

    let!(:new_scheduled_at) { Yt::Timestamp.parse("#{rand(30) + 1} Jan 2020", Time.now) }

    context 'passing the parameter in underscore syntax' do
      let(:attrs) { {publish_at: new_scheduled_at} }

      specify 'only updates the timestamp to publish the video' do
        expect(video.update attrs).to be true
        expect(video.privacy_status).to eq old_privacy_status
        expect(video.title).to eq old_title
        # NOTE: This is another irrational behavior of YouTube API. In short,
        # the response of Video#update *does not* include the publishAt value
        # even if it exists. You need to call Video#list again to get it.
        video = Yt::Video.new id: id, auth: $account
        expect(video.scheduled_at).to eq new_scheduled_at
        # Setting a private (scheduled) video to private has no effect:
        expect(video.update privacy_status: 'private').to be true
        video = Yt::Video.new id: id, auth: $account
        expect(video.scheduled_at).to eq new_scheduled_at
        # Setting a private (scheduled) video to unlisted/public removes publishAt:
        expect(video.update privacy_status: 'unlisted').to be true
        video = Yt::Video.new id: id, auth: $account
        expect(video.scheduled_at).to be_nil
      end
    end

    context 'passing the parameter in camel-case syntax' do
      let(:attrs) { {publishAt: new_scheduled_at} }

      specify 'only updates the timestamp to publish the video' do
        expect(video.update attrs).to be true
        expect(video.scheduled_at).to eq new_scheduled_at
        expect(video.privacy_status).to eq old_privacy_status
        expect(video.title).to eq old_title
      end
    end
  end

  # @note: This should somehow test that the thumbnail *changes*. However,
  #   YouTube does not change the URL of the thumbnail even though the content
  #   changes. A full test would have to *download* the thumbnails before and
  #   after, and compare the files. For now, not raising error is enough.
  #   Eventually, change to `expect{update}.to change{video.thumbnail_url}`
  context 'given one of my own videos for which I want to upload a thumbnail' do
    let(:id) { $account.videos.where(order: 'viewCount').first.id }
    let(:update) { video.upload_thumbnail path_or_url }

    context 'given the path to a local JPG image file' do
      let(:path_or_url) { File.expand_path '../thumbnail.jpg', __FILE__ }

      it { expect{update}.not_to raise_error }
    end

    context 'given the path to a remote PNG image file' do
      let(:path_or_url) { 'https://bit.ly/yt_thumbnail' }

      it { expect{update}.not_to raise_error }
    end

    context 'given an invalid URL' do
      let(:path_or_url) { 'this-is-not-a-url' }

      it { expect{update}.to raise_error Yt::Errors::RequestError }
    end
  end

  # @note: This test is separated from the block above because YouTube only
  #   returns file details for *some videos*: "The fileDetails object will
  #   only be returned if the processingDetails.fileAvailability property
  #   has a value of available.". Therefore, just to test fileDetails, we use a
  #   different video that (for some unknown reason) is marked as 'available'.
  #   Also note that I was not able to find a single video returning fileName,
  #   therefore video.file_name is not returned by Yt, until it can be tested.
  # @see https://developers.google.com/youtube/v3/docs/videos#processingDetails.fileDetailsAvailability
  context 'given one of my own *available* videos' do
    let(:id) { 'yCmaOvUFhlI' }

    it 'returns valid file details' do
      expect(video.file_size).to be_an Integer
      expect(video.file_type).to be_a String
      expect(video.container).to be_a String
    end
  end
end
# encoding: UTF-8

require 'spec_helper'
require 'yt/models/video'

describe Yt::Video, :device_app do
  subject(:video) { Yt::Video.new id: id, auth: $account }

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
      expect(video.dislike_count).to be_an Integer
      expect(video.favorite_count).to be_an Integer
      expect(video.comment_count).to be_an Integer
      expect(video.duration).to be_an Integer
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
    let(:id) { 'PqzGI8gO_gk' }

    it 'returns valid live streaming details' do
      expect(video.actual_start_time).to be_nil
      expect(video.actual_end_time).to be_nil
      expect(video.scheduled_start_time).to be_a Time
      expect(video.scheduled_end_time).to be_nil
    end
  end

  context 'given someone else’s past live video broadcast' do
    let(:id) { 'COOM8_tOy6U' }

    it 'returns valid live streaming details' do
      expect(video.actual_start_time).to be_a Time
      expect(video.actual_end_time).to be_a Time
      expect(video.scheduled_start_time).to be_a Time
      expect(video.scheduled_end_time).to be_a Time
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
    before(:all) { @tmp_video = $account.upload_video 'https://bit.ly/yt_test', title: "Yt Test Delete Video #{rand}" }
    let(:id) { @tmp_video.id }

    it { expect(video.delete).to be true }
  end

  context 'given one of my own videos that I want to update' do
    let(:id) { $account.videos.where(order: 'viewCount').first.id }
    let!(:old_title) { video.title }
    let!(:old_privacy_status) { video.privacy_status }
    let(:update) { video.update attrs }

    context 'given I update the title' do
      # NOTE: The use of UTF-8 characters is to test that we can pass up to
      # 50 characters, independently of their representation
      let(:attrs) { {title: "Yt Example Update Video #{rand} - ®•♡❥❦❧☙"} }

      specify 'only updates the title' do
        expect(update).to be true
        expect(video.title).not_to eq old_title
        expect(video.privacy_status).to eq old_privacy_status
      end
    end

    context 'given I update the description' do
      let!(:old_description) { video.description }
      let(:attrs) { {description: "Yt Example Description  #{rand} - ®•♡❥❦❧☙"} }

      specify 'only updates the description' do
        expect(update).to be true
        expect(video.description).not_to eq old_description
        expect(video.title).to eq old_title
        expect(video.privacy_status).to eq old_privacy_status
      end
    end

    context 'given I update the tags' do
      let!(:old_tags) { video.tags }
      let(:attrs) { {tags: ["Yt Test Tag #{rand}"]} }

      specify 'only updates the tag' do
        expect(update).to be true
        expect(video.tags).not_to eq old_tags
        expect(video.title).to eq old_title
        expect(video.privacy_status).to eq old_privacy_status
      end
    end

    context 'given I update the category ID' do
      let!(:old_category_id) { video.category_id }
      let!(:new_category_id) { old_category_id == '22' ? '21' : '22' }

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

      # @note: This test is a reflection of another irrational behavior of
      #   YouTube API. Although 'embeddable' can be passed as an 'update'
      #   attribute according to the documentation, it simply does not work.
      #   The day YouTube fixes it, then this test will finally fail and will
      #   be removed, documenting how to update 'embeddable' too.
      # @see https://developers.google.com/youtube/v3/docs/videos/update
      # @see https://code.google.com/p/gdata-issues/issues/detail?id=4861
      specify 'does not update the embeddable status' do
        expect(update).to be true
        expect(video.embeddable?).to eq old_embeddable
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

    it 'returns valid reports for video-related metrics' do
      # Some reports are only available to Content Owners.
      # See content owner test for more details about what the methods return.
      expect{video.views}.not_to raise_error
      expect{video.comments}.not_to raise_error
      expect{video.likes}.not_to raise_error
      expect{video.dislikes}.not_to raise_error
      expect{video.shares}.not_to raise_error
      expect{video.subscribers_gained}.not_to raise_error
      expect{video.subscribers_lost}.not_to raise_error
      expect{video.videos_added_to_playlists}.not_to raise_error
      expect{video.videos_removed_from_playlists}.not_to raise_error
      expect{video.estimated_minutes_watched}.not_to raise_error
      expect{video.average_view_duration}.not_to raise_error
      expect{video.average_view_percentage}.not_to raise_error
      expect{video.annotation_clicks}.not_to raise_error
      expect{video.annotation_click_through_rate}.not_to raise_error
      expect{video.annotation_close_rate}.not_to raise_error
      expect{video.viewer_percentage}.not_to raise_error
      expect{video.estimated_revenue}.to raise_error Yt::Errors::Unauthorized
      expect{video.ad_impressions}.to raise_error Yt::Errors::Unauthorized
      expect{video.monetized_playbacks}.to raise_error Yt::Errors::Unauthorized
      expect{video.playback_based_cpm}.to raise_error Yt::Errors::Unauthorized
      expect{video.advertising_options_set}.to raise_error Yt::Errors::Forbidden
    end
  end

  # @note: This test is separated from the block above because, for some
  #   undocumented reasons, if an existing video was private, then set to
  #   unlisted, then set to private again, YouTube _sometimes_ raises a
  #   400 Error when trying to set the publishAt timestamp.
  #   Therefore, just to test the updating of publishAt, we use a brand new
  #   video (set to private), rather than reusing an existing one as above.
  context 'given one of my own *private* videos that I want to update' do
    before { @tmp_video = $account.upload_video 'https://bit.ly/yt_test', title: old_title, privacy_status: old_privacy_status }
    let(:id) { @tmp_video.id }
    let!(:old_title) { "Yt Test Update publishAt Video #{rand}" }
    let!(:old_privacy_status) { 'private' }
    after  { video.delete }

    let!(:new_scheduled_at) { Yt::Timestamp.parse("#{rand(30) + 1} Jan 2020", Time.now) }

    context 'passing the parameter in underscore syntax' do
      let(:attrs) { {publish_at: new_scheduled_at} }

      specify 'only updates the timestamp to publish the video' do
        expect(video.update attrs).to be true
        expect(video.privacy_status).to eq old_privacy_status
        expect(video.title).to eq old_title
        # NOTE: This is another irrational behavior of YouTube API. In short,
        # the response of Video#update *does not* include the publishAt value
        # even if it exists. You need to call Video#list again to get it.
        video = Yt::Video.new id: id, auth: $account
        expect(video.scheduled_at).to eq new_scheduled_at
        # Setting a private (scheduled) video to private has no effect:
        expect(video.update privacy_status: 'private').to be true
        video = Yt::Video.new id: id, auth: $account
        expect(video.scheduled_at).to eq new_scheduled_at
        # Setting a private (scheduled) video to unlisted/public removes publishAt:
        expect(video.update privacy_status: 'unlisted').to be true
        video = Yt::Video.new id: id, auth: $account
        expect(video.scheduled_at).to be_nil
      end
    end

    context 'passing the parameter in camel-case syntax' do
      let(:attrs) { {publishAt: new_scheduled_at} }

      specify 'only updates the timestamp to publish the video' do
        expect(video.update attrs).to be true
        expect(video.scheduled_at).to eq new_scheduled_at
        expect(video.privacy_status).to eq old_privacy_status
        expect(video.title).to eq old_title
      end
    end
  end

  # @note: This should somehow test that the thumbnail *changes*. However,
  #   YouTube does not change the URL of the thumbnail even though the content
  #   changes. A full test would have to *download* the thumbnails before and
  #   after, and compare the files. For now, not raising error is enough.
  #   Eventually, change to `expect{update}.to change{video.thumbnail_url}`
  context 'given one of my own videos for which I want to upload a thumbnail' do
    let(:id) { $account.videos.where(order: 'viewCount').first.id }
    let(:update) { video.upload_thumbnail path_or_url }

    context 'given the path to a local JPG image file' do
      let(:path_or_url) { File.expand_path '../thumbnail.jpg', __FILE__ }

      it { expect{update}.not_to raise_error }
    end

    context 'given the path to a remote PNG image file' do
      let(:path_or_url) { 'https://bit.ly/yt_thumbnail' }

      it { expect{update}.not_to raise_error }
    end

    context 'given an invalid URL' do
      let(:path_or_url) { 'this-is-not-a-url' }

      it { expect{update}.to raise_error Yt::Errors::RequestError }
    end
  end

  # @note: This test is separated from the block above because YouTube only
  #   returns file details for *some videos*: "The fileDetails object will
  #   only be returned if the processingDetails.fileAvailability property
  #   has a value of available.". Therefore, just to test fileDetails, we use a
  #   different video that (for some unknown reason) is marked as 'available'.
  #   Also note that I was not able to find a single video returning fileName,
  #   therefore video.file_name is not returned by Yt, until it can be tested.
  # @see https://developers.google.com/youtube/v3/docs/videos#processingDetails.fileDetailsAvailability
  context 'given one of my own *available* videos' do
    let(:id) { 'yCmaOvUFhlI' }

    it 'returns valid file details' do
      expect(video.file_size).to be_an Integer
      expect(video.file_type).to be_a String
      expect(video.container).to be_a String
    end
  end
end
# encoding: UTF-8

require 'spec_helper'
require 'yt/models/video'

describe Yt::Video, :device_app do
  subject(:video) { Yt::Video.new id: id, auth: $account }

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
      expect(video.dislike_count).to be_an Integer
      expect(video.favorite_count).to be_an Integer
      expect(video.comment_count).to be_an Integer
      expect(video.duration).to be_an Integer
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
    let(:id) { 'PqzGI8gO_gk' }

    it 'returns valid live streaming details' do
      expect(video.actual_start_time).to be_nil
      expect(video.actual_end_time).to be_nil
      expect(video.scheduled_start_time).to be_a Time
      expect(video.scheduled_end_time).to be_nil
    end
  end

  context 'given someone else’s past live video broadcast' do
    let(:id) { 'COOM8_tOy6U' }

    it 'returns valid live streaming details' do
      expect(video.actual_start_time).to be_a Time
      expect(video.actual_end_time).to be_a Time
      expect(video.scheduled_start_time).to be_a Time
      expect(video.scheduled_end_time).to be_a Time
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
    before(:all) { @tmp_video = $account.upload_video 'https://bit.ly/yt_test', title: "Yt Test Delete Video #{rand}" }
    let(:id) { @tmp_video.id }

    it { expect(video.delete).to be true }
  end

  context 'given one of my own videos that I want to update' do
    let(:id) { $account.videos.where(order: 'viewCount').first.id }
    let!(:old_title) { video.title }
    let!(:old_privacy_status) { video.privacy_status }
    let(:update) { video.update attrs }

    context 'given I update the title' do
      # NOTE: The use of UTF-8 characters is to test that we can pass up to
      # 50 characters, independently of their representation
      let(:attrs) { {title: "Yt Example Update Video #{rand} - ®•♡❥❦❧☙"} }

      specify 'only updates the title' do
        expect(update).to be true
        expect(video.title).not_to eq old_title
        expect(video.privacy_status).to eq old_privacy_status
      end
    end

    context 'given I update the description' do
      let!(:old_description) { video.description }
      let(:attrs) { {description: "Yt Example Description  #{rand} - ®•♡❥❦❧☙"} }

      specify 'only updates the description' do
        expect(update).to be true
        expect(video.description).not_to eq old_description
        expect(video.title).to eq old_title
        expect(video.privacy_status).to eq old_privacy_status
      end
    end

    context 'given I update the tags' do
      let!(:old_tags) { video.tags }
      let(:attrs) { {tags: ["Yt Test Tag #{rand}"]} }

      specify 'only updates the tag' do
        expect(update).to be true
        expect(video.tags).not_to eq old_tags
        expect(video.title).to eq old_title
        expect(video.privacy_status).to eq old_privacy_status
      end
    end

    context 'given I update the category ID' do
      let!(:old_category_id) { video.category_id }
      let!(:new_category_id) { old_category_id == '22' ? '21' : '22' }

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

      # @note: This test is a reflection of another irrational behavior of
      #   YouTube API. Although 'embeddable' can be passed as an 'update'
      #   attribute according to the documentation, it simply does not work.
      #   The day YouTube fixes it, then this test will finally fail and will
      #   be removed, documenting how to update 'embeddable' too.
      # @see https://developers.google.com/youtube/v3/docs/videos/update
      # @see https://code.google.com/p/gdata-issues/issues/detail?id=4861
      specify 'does not update the embeddable status' do
        expect(update).to be true
        expect(video.embeddable?).to eq old_embeddable
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

    it 'returns valid reports for video-related metrics' do
      # Some reports are only available to Content Owners.
      # See content owner test for more details about what the methods return.
      expect{video.views}.not_to raise_error
      expect{video.comments}.not_to raise_error
      expect{video.likes}.not_to raise_error
      expect{video.dislikes}.not_to raise_error
      expect{video.shares}.not_to raise_error
      expect{video.subscribers_gained}.not_to raise_error
      expect{video.subscribers_lost}.not_to raise_error
      expect{video.videos_added_to_playlists}.not_to raise_error
      expect{video.videos_removed_from_playlists}.not_to raise_error
      expect{video.estimated_minutes_watched}.not_to raise_error
      expect{video.average_view_duration}.not_to raise_error
      expect{video.average_view_percentage}.not_to raise_error
      expect{video.annotation_clicks}.not_to raise_error
      expect{video.annotation_click_through_rate}.not_to raise_error
      expect{video.annotation_close_rate}.not_to raise_error
      expect{video.viewer_percentage}.not_to raise_error
      expect{video.estimated_revenue}.to raise_error Yt::Errors::Unauthorized
      expect{video.ad_impressions}.to raise_error Yt::Errors::Unauthorized
      expect{video.monetized_playbacks}.to raise_error Yt::Errors::Unauthorized
      expect{video.playback_based_cpm}.to raise_error Yt::Errors::Unauthorized
      expect{video.advertising_options_set}.to raise_error Yt::Errors::Forbidden

    end
  end

  # @note: This test is separated from the block above because, for some
  #   undocumented reasons, if an existing video was private, then set to
  #   unlisted, then set to private again, YouTube _sometimes_ raises a
  #   400 Error when trying to set the publishAt timestamp.
  #   Therefore, just to test the updating of publishAt, we use a brand new
  #   video (set to private), rather than reusing an existing one as above.
  context 'given one of my own *private* videos that I want to update' do
    before { @tmp_video = $account.upload_video 'https://bit.ly/yt_test', title: old_title, privacy_status: old_privacy_status }
    let(:id) { @tmp_video.id }
    let!(:old_title) { "Yt Test Update publishAt Video #{rand}" }
    let!(:old_privacy_status) { 'private' }
    after  { video.delete }

    let!(:new_scheduled_at) { Yt::Timestamp.parse("#{rand(30) + 1} Jan 2020", Time.now) }

    context 'passing the parameter in underscore syntax' do
      let(:attrs) { {publish_at: new_scheduled_at} }

      specify 'only updates the timestamp to publish the video' do
        expect(video.update attrs).to be true
        expect(video.privacy_status).to eq old_privacy_status
        expect(video.title).to eq old_title
        # NOTE: This is another irrational behavior of YouTube API. In short,
        # the response of Video#update *does not* include the publishAt value
        # even if it exists. You need to call Video#list again to get it.
        video = Yt::Video.new id: id, auth: $account
        expect(video.scheduled_at).to eq new_scheduled_at
        # Setting a private (scheduled) video to private has no effect:
        expect(video.update privacy_status: 'private').to be true
        video = Yt::Video.new id: id, auth: $account
        expect(video.scheduled_at).to eq new_scheduled_at
        # Setting a private (scheduled) video to unlisted/public removes publishAt:
        expect(video.update privacy_status: 'unlisted').to be true
        video = Yt::Video.new id: id, auth: $account
        expect(video.scheduled_at).to be_nil
      end
    end

    context 'passing the parameter in camel-case syntax' do
      let(:attrs) { {publishAt: new_scheduled_at} }

      specify 'only updates the timestamp to publish the video' do
        expect(video.update attrs).to be true
        expect(video.scheduled_at).to eq new_scheduled_at
        expect(video.privacy_status).to eq old_privacy_status
        expect(video.title).to eq old_title
      end
    end
  end

  # @note: This should somehow test that the thumbnail *changes*. However,
  #   YouTube does not change the URL of the thumbnail even though the content
  #   changes. A full test would have to *download* the thumbnails before and
  #   after, and compare the files. For now, not raising error is enough.
  #   Eventually, change to `expect{update}.to change{video.thumbnail_url}`
  context 'given one of my own videos for which I want to upload a thumbnail' do
    let(:id) { $account.videos.where(order: 'viewCount').first.id }
    let(:update) { video.upload_thumbnail path_or_url }

    context 'given the path to a local JPG image file' do
      let(:path_or_url) { File.expand_path '../thumbnail.jpg', __FILE__ }

      it { expect{update}.not_to raise_error }
    end

    context 'given the path to a remote PNG image file' do
      let(:path_or_url) { 'https://bit.ly/yt_thumbnail' }

      it { expect{update}.not_to raise_error }
    end

    context 'given an invalid URL' do
      let(:path_or_url) { 'this-is-not-a-url' }

      it { expect{update}.to raise_error Yt::Errors::RequestError }
    end
  end

  # @note: This test is separated from the block above because YouTube only
  #   returns file details for *some videos*: "The fileDetails object will
  #   only be returned if the processingDetails.fileAvailability property
  #   has a value of available.". Therefore, just to test fileDetails, we use a
  #   different video that (for some unknown reason) is marked as 'available'.
  #   Also note that I was not able to find a single video returning fileName,
  #   therefore video.file_name is not returned by Yt, until it can be tested.
  # @see https://developers.google.com/youtube/v3/docs/videos#processingDetails.fileDetailsAvailability
  context 'given one of my own *available* videos' do
    let(:id) { 'yCmaOvUFhlI' }

    it 'returns valid file details' do
      expect(video.file_size).to be_an Integer
      expect(video.file_type).to be_a String
      expect(video.container).to be_a String
    end
  end
end
# encoding: UTF-8

require 'spec_helper'
require 'yt/models/video'

describe Yt::Video, :device_app do
  subject(:video) { Yt::Video.new id: id, auth: $account }

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
      expect(video.dislike_count).to be_an Integer
      expect(video.favorite_count).to be_an Integer
      expect(video.comment_count).to be_an Integer
      expect(video.duration).to be_an Integer
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
    let(:id) { 'PqzGI8gO_gk' }

    it 'returns valid live streaming details' do
      expect(video.actual_start_time).to be_nil
      expect(video.actual_end_time).to be_nil
      expect(video.scheduled_start_time).to be_a Time
      expect(video.scheduled_end_time).to be_nil
    end
  end

  context 'given someone else’s past live video broadcast' do
    let(:id) { 'COOM8_tOy6U' }

    it 'returns valid live streaming details' do
      expect(video.actual_start_time).to be_a Time
      expect(video.actual_end_time).to be_a Time
      expect(video.scheduled_start_time).to be_a Time
      expect(video.scheduled_end_time).to be_a Time
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
    before(:all) { @tmp_video = $account.upload_video 'https://bit.ly/yt_test', title: "Yt Test Delete Video #{rand}" }
    let(:id) { @tmp_video.id }

    it { expect(video.delete).to be true }
  end

  context 'given one of my own videos that I want to update' do
    let(:id) { $account.videos.where(order: 'viewCount').first.id }
    let!(:old_title) { video.title }
    let!(:old_privacy_status) { video.privacy_status }
    let(:update) { video.update attrs }

    context 'given I update the title' do
      # NOTE: The use of UTF-8 characters is to test that we can pass up to
      # 50 characters, independently of their representation
      let(:attrs) { {title: "Yt Example Update Video #{rand} - ®•♡❥❦❧☙"} }

      specify 'only updates the title' do
        expect(update).to be true
        expect(video.title).not_to eq old_title
        expect(video.privacy_status).to eq old_privacy_status
      end
    end

    context 'given I update the description' do
      let!(:old_description) { video.description }
      let(:attrs) { {description: "Yt Example Description  #{rand} - ®•♡❥❦❧☙"} }

      specify 'only updates the description' do
        expect(update).to be true
        expect(video.description).not_to eq old_description
        expect(video.title).to eq old_title
        expect(video.privacy_status).to eq old_privacy_status
      end
    end

    context 'given I update the tags' do
      let!(:old_tags) { video.tags }
      let(:attrs) { {tags: ["Yt Test Tag #{rand}"]} }

      specify 'only updates the tag' do
        expect(update).to be true
        expect(video.tags).not_to eq old_tags
        expect(video.title).to eq old_title
        expect(video.privacy_status).to eq old_privacy_status
      end
    end

    context 'given I update the category ID' do
      let!(:old_category_id) { video.category_id }
      let!(:new_category_id) { old_category_id == '22' ? '21' : '22' }

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

      # @note: This test is a reflection of another irrational behavior of
      #   YouTube API. Although 'embeddable' can be passed as an 'update'
      #   attribute according to the documentation, it simply does not work.
      #   The day YouTube fixes it, then this test will finally fail and will
      #   be removed, documenting how to update 'embeddable' too.
      # @see https://developers.google.com/youtube/v3/docs/videos/update
      # @see https://code.google.com/p/gdata-issues/issues/detail?id=4861
      specify 'does not update the embeddable status' do
        expect(update).to be true
        expect(video.embeddable?).to eq old_embeddable
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

    it 'returns valid reports for video-related metrics' do
      # Some reports are only available to Content Owners.
      # See content owner test for more details about what the methods return.
      expect{video.views}.not_to raise_error
      expect{video.comments}.not_to raise_error
      expect{video.likes}.not_to raise_error
      expect{video.dislikes}.not_to raise_error
      expect{video.shares}.not_to raise_error
      expect{video.subscribers_gained}.not_to raise_error
      expect{video.subscribers_lost}.not_to raise_error
      expect{video.videos_added_to_playlists}.not_to raise_error
      expect{video.videos_removed_from_playlists}.not_to raise_error
      expect{video.estimated_minutes_watched}.not_to raise_error
      expect{video.average_view_duration}.not_to raise_error
      expect{video.average_view_percentage}.not_to raise_error
      expect{video.annotation_clicks}.not_to raise_error
      expect{video.annotation_click_through_rate}.not_to raise_error
      expect{video.annotation_close_rate}.not_to raise_error
      expect{video.viewer_percentage}.not_to raise_error
      expect{video.estimated_revenue}.to raise_error Yt::Errors::Unauthorized
      expect{video.ad_impressions}.to raise_error Yt::Errors::Unauthorized
      expect{video.monetized_playbacks}.to raise_error Yt::Errors::Unauthorized
      expect{video.playback_based_cpm}.to raise_error Yt::Errors::Unauthorized
      expect{video.advertising_options_set}.to raise_error Yt::Errors::Forbidden
    end
  end

  # @note: This test is separated from the block above because, for some
  #   undocumented reasons, if an existing video was private, then set to
  #   unlisted, then set to private again, YouTube _sometimes_ raises a
  #   400 Error when trying to set the publishAt timestamp.
  #   Therefore, just to test the updating of publishAt, we use a brand new
  #   video (set to private), rather than reusing an existing one as above.
  context 'given one of my own *private* videos that I want to update' do
    before { @tmp_video = $account.upload_video 'https://bit.ly/yt_test', title: old_title, privacy_status: old_privacy_status }
    let(:id) { @tmp_video.id }
    let!(:old_title) { "Yt Test Update publishAt Video #{rand}" }
    let!(:old_privacy_status) { 'private' }
    after  { video.delete }

    let!(:new_scheduled_at) { Yt::Timestamp.parse("#{rand(30) + 1} Jan 2020", Time.now) }

    context 'passing the parameter in underscore syntax' do
      let(:attrs) { {publish_at: new_scheduled_at} }

      specify 'only updates the timestamp to publish the video' do
        expect(video.update attrs).to be true
        expect(video.privacy_status).to eq old_privacy_status
        expect(video.title).to eq old_title
        # NOTE: This is another irrational behavior of YouTube API. In short,
        # the response of Video#update *does not* include the publishAt value
        # even if it exists. You need to call Video#list again to get it.
        video = Yt::Video.new id: id, auth: $account
        expect(video.scheduled_at).to eq new_scheduled_at
        # Setting a private (scheduled) video to private has no effect:
        expect(video.update privacy_status: 'private').to be true
        video = Yt::Video.new id: id, auth: $account
        expect(video.scheduled_at).to eq new_scheduled_at
        # Setting a private (scheduled) video to unlisted/public removes publishAt:
        expect(video.update privacy_status: 'unlisted').to be true
        video = Yt::Video.new id: id, auth: $account
        expect(video.scheduled_at).to be_nil
      end
    end

    context 'passing the parameter in camel-case syntax' do
      let(:attrs) { {publishAt: new_scheduled_at} }

      specify 'only updates the timestamp to publish the video' do
        expect(video.update attrs).to be true
        expect(video.scheduled_at).to eq new_scheduled_at
        expect(video.privacy_status).to eq old_privacy_status
        expect(video.title).to eq old_title
      end
    end
  end

  # @note: This should somehow test that the thumbnail *changes*. However,
  #   YouTube does not change the URL of the thumbnail even though the content
  #   changes. A full test would have to *download* the thumbnails before and
  #   after, and compare the files. For now, not raising error is enough.
  #   Eventually, change to `expect{update}.to change{video.thumbnail_url}`
  context 'given one of my own videos for which I want to upload a thumbnail' do
    let(:id) { $account.videos.where(order: 'viewCount').first.id }
    let(:update) { video.upload_thumbnail path_or_url }

    context 'given the path to a local JPG image file' do
      let(:path_or_url) { File.expand_path '../thumbnail.jpg', __FILE__ }

      it { expect{update}.not_to raise_error }
    end

    context 'given the path to a remote PNG image file' do
      let(:path_or_url) { 'https://bit.ly/yt_thumbnail' }

      it { expect{update}.not_to raise_error }
    end

    context 'given an invalid URL' do
      let(:path_or_url) { 'this-is-not-a-url' }

      it { expect{update}.to raise_error Yt::Errors::RequestError }
    end
  end

  # @note: This test is separated from the block above because YouTube only
  #   returns file details for *some videos*: "The fileDetails object will
  #   only be returned if the processingDetails.fileAvailability property
  #   has a value of available.". Therefore, just to test fileDetails, we use a
  #   different video that (for some unknown reason) is marked as 'available'.
  #   Also note that I was not able to find a single video returning fileName,
  #   therefore video.file_name is not returned by Yt, until it can be tested.
  # @see https://developers.google.com/youtube/v3/docs/videos#processingDetails.fileDetailsAvailability
  context 'given one of my own *available* videos' do
    let(:id) { 'yCmaOvUFhlI' }

    it 'returns valid file details' do
      expect(video.file_size).to be_an Integer
      expect(video.file_type).to be_a String
      expect(video.container).to be_a String
    end
  end
end
