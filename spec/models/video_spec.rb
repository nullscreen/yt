require 'spec_helper'
require 'yt/models/video'

describe Yt::Video do
  subject(:video) { Yt::Video.new attrs }

  describe '#snippet' do
    context 'given fetching a video returns a snippet' do
      let(:attrs) { {snippet: {"title"=>"Fullscreen Creator Platform"}} }
      it { expect(video.snippet).to be_a Yt::Snippet }
    end
  end


  describe '#title' do
    context 'given a snippet with a title' do
      let(:attrs) { {snippet: {"title"=>"Fullscreen Creator Platform"}} }
      it { expect(video.title).to eq 'Fullscreen Creator Platform' }
    end

    context 'given a snippet without a title' do
      let(:attrs) { {snippet: {}} }
      it { expect(video.title).to eq '' }
    end
  end

  describe '#description' do
    context 'given a snippet with a description' do
      let(:attrs) { {snippet: {"description"=>"A cool video."}} }
      it { expect(video.description).to eq 'A cool video.' }
    end

    context 'given a snippet without a description' do
      let(:attrs) { {snippet: {}} }
      it { expect(video.description).to eq '' }
    end
  end

  describe '#thumbnail_url' do
    context 'given a snippet with thumbnails' do
      let(:attrs) { {snippet: {"thumbnails"=>{
        "default"=>{"url"=> "http://example.com/120x90.jpg"},
        "medium"=>{"url"=> "http://example.com/320x180.jpg"},
      }}} }
      it { expect(video.thumbnail_url).to eq 'http://example.com/120x90.jpg' }
      it { expect(video.thumbnail_url 'default').to eq 'http://example.com/120x90.jpg' }
      it { expect(video.thumbnail_url :default).to eq 'http://example.com/120x90.jpg' }
      it { expect(video.thumbnail_url :medium).to eq 'http://example.com/320x180.jpg' }
      it { expect(video.thumbnail_url :high).to be_nil }
    end

    context 'given a snippet without thumbnails' do
      let(:attrs) { {snippet: {}} }
      it { expect(video.thumbnail_url).to be_nil }
    end
  end

  describe '#published_at' do
    context 'given a snippet with a timestamp' do
      let(:attrs) { {snippet: {"publishedAt"=>"2014-04-22T19:14:49.000Z"}} }
      it { expect(video.published_at.year).to be 2014 }
    end
  end

  describe '#channel_id' do
    context 'given a snippet with a channel ID' do
      let(:attrs) { {snippet: {"channelId"=>"UCxO1tY8h1AhOz0T4ENwmpow"}} }
      it { expect(video.channel_id).to eq 'UCxO1tY8h1AhOz0T4ENwmpow' }
    end

    context 'given a snippet without a channel ID' do
      let(:attrs) { {snippet: {}} }
      it { expect(video.channel_id).to be_nil }
    end
  end

  describe '#channel_title' do
    context 'given a snippet with a channel title' do
      let(:attrs) { {snippet: {"channelTitle"=>"Fullscreen"}} }
      it { expect(video.channel_title).to eq 'Fullscreen' }
    end

    context 'given a snippet without a channel title' do
      let(:attrs) { {snippet: {}} }
      it { expect(video.channel_title).to be_nil }
    end
  end

  describe '#live_broadcast_content' do
    context 'given a snippet with live broadcast content' do
      let(:attrs) { {snippet: {"liveBroadcastContent"=>"live"}} }
      it { expect(video.live_broadcast_content).to eq 'live' }
    end

    context 'given a snippet without live broadcast content' do
      let(:attrs) { {snippet: {}} }
      it { expect(video.live_broadcast_content).to be_nil }
    end
  end

  describe '#tags' do
    context 'given a snippet with tags' do
      let(:attrs) { {snippet: {"tags"=>["promotion", "new media"]}} }
      it { expect(video.tags).to eq ["promotion", "new media"] }
    end

    context 'given a snippet without tags' do
      let(:attrs) { {snippet: {}} }
      it { expect(video.tags).to eq [] }
    end
  end

  describe '#category_id' do
    context 'given a snippet with a category ID' do
      let(:attrs) { {snippet: {"categoryId"=>"22"}} }
      it { expect(video.category_id).to eq '22' }
    end

    context 'given a snippet without a category ID' do
      let(:attrs) { {snippet: {}} }
      it { expect(video.category_id).to be_nil }
    end
  end

  describe '#deleted?' do
    context 'given fetching a status returns uploadStatus "deleted"' do
      let(:attrs) { {status: {"uploadStatus"=>"deleted"}} }
      it { expect(video).to be_deleted }
    end

    context 'given fetching a status does not return uploadStatus "deleted"' do
      let(:attrs) { {status: {"uploadStatus"=>"uploaded"}} }
      it { expect(video).not_to be_deleted }
    end
  end

  describe '#failed?' do
    context 'given fetching a status returns uploadStatus "failed"' do
      let(:attrs) { {status: {"uploadStatus"=>"failed"}} }
      it { expect(video).to be_failed }
    end

    context 'given fetching a status does not return uploadStatus "failed"' do
      let(:attrs) { {status: {"uploadStatus"=>"uploaded"}} }
      it { expect(video).not_to be_failed }
    end
  end

  describe '#processed?' do
    context 'given fetching a status returns uploadStatus "processed"' do
      let(:attrs) { {status: {"uploadStatus"=>"processed"}} }
      it { expect(video).to be_processed }
    end

    context 'given fetching a status does not return uploadStatus "processed"' do
      let(:attrs) { {status: {"uploadStatus"=>"uploaded"}} }
      it { expect(video).not_to be_processed }
    end
  end

  describe '#rejected?' do
    context 'given fetching a status returns uploadStatus "rejected"' do
      let(:attrs) { {status: {"uploadStatus"=>"rejected"}} }
      it { expect(video).to be_rejected }
    end

    context 'given fetching a status does not return uploadStatus "rejected"' do
      let(:attrs) { {status: {"uploadStatus"=>"uploaded"}} }
      it { expect(video).not_to be_rejected }
    end
  end

  describe '#uploading?' do
    context 'given fetching a status returns uploadStatus "uploaded"' do
      let(:attrs) { {status: {"uploadStatus"=>"uploaded"}} }
      it { expect(video).to be_uploading }
    end

    context 'given fetching a status does not return uploadStatus "uploaded"' do
      let(:attrs) { {status: {"uploadStatus"=>"failed"}} }
      it { expect(video).not_to be_uploading }
    end
  end

  describe '#uses_unsupported_codec?' do
    context 'given fetching a status returns failureReason "codec"' do
      let(:attrs) { {status: {"uploadStatus"=>"failed", "failureReason"=>"codec"}} }
      it { expect(video.uses_unsupported_codec?).to be true }
    end

    context 'given fetching a status does not return failureReason "codec"' do
      let(:attrs) { {status: {"uploadStatus"=>"failed"}} }
      it { expect(video.uses_unsupported_codec?).to be false }
    end
  end

  describe '#conversion_failed?' do
    context 'given fetching a status returns failureReason "conversion"' do
      let(:attrs) { {status: {"uploadStatus"=>"failed", "failureReason"=>"conversion"}} }
      it { expect(video).to have_failed_conversion }
    end

    context 'given fetching a status does not return failureReason "conversion"' do
      let(:attrs) { {status: {"uploadStatus"=>"failed"}} }
      it { expect(video).not_to have_failed_conversion }
    end
  end

  describe '#empty_file?' do
    context 'given fetching a status returns failureReason "emptyFile"' do
      let(:attrs) { {status: {"uploadStatus"=>"failed", "failureReason"=>"emptyFile"}} }
      it { expect(video).to be_empty }
    end

    context 'given fetching a status does not return failureReason "emptyFile"' do
      let(:attrs) { {status: {"uploadStatus"=>"failed"}} }
      it { expect(video).not_to be_empty }
    end
  end

  describe '#invalid_file?' do
    context 'given fetching a status returns failureReason "invalidFile"' do
      let(:attrs) { {status: {"uploadStatus"=>"failed", "failureReason"=>"invalidFile"}} }
      it { expect(video).to be_invalid }
    end

    context 'given fetching a status does not return failureReason "invalidFile"' do
      let(:attrs) { {status: {"uploadStatus"=>"failed"}} }
      it { expect(video).not_to be_invalid }
    end
  end

  describe '#too_small?' do
    context 'given fetching a status returns failureReason "tooSmall"' do
      let(:attrs) { {status: {"uploadStatus"=>"failed", "failureReason"=>"tooSmall"}} }
      it { expect(video).to be_too_small }
    end

    context 'given fetching a status does not return failureReason "tooSmall"' do
      let(:attrs) { {status: {"uploadStatus"=>"failed"}} }
      it { expect(video).not_to be_too_small }
    end
  end

  describe '#upload_aborted?' do
    context 'given fetching a status returns failureReason "uploadAborted"' do
      let(:attrs) { {status: {"uploadStatus"=>"failed", "failureReason"=>"uploadAborted"}} }
      it { expect(video).to be_aborted }
    end

    context 'given fetching a status does not return failureReason "uploadAborted"' do
      let(:attrs) { {status: {"uploadStatus"=>"failed"}} }
      it { expect(video).not_to be_aborted }
    end
  end

  describe '#claimed?' do
    context 'given fetching a status returns rejectionReason "claim"' do
      let(:attrs) { {status: {"uploadStatus"=>"rejected", "rejectionReason"=>"claim"}} }
      it { expect(video).to be_claimed }
    end

    context 'given fetching a status does not return rejectionReason "claim"' do
      let(:attrs) { {status: {"uploadStatus"=>"rejected"}} }
      it { expect(video).not_to be_claimed }
    end
  end

  describe '#infringes_copyright?' do
    context 'given fetching a status returns rejectionReason "copyright"' do
      let(:attrs) { {status: {"uploadStatus"=>"rejected", "rejectionReason"=>"copyright"}} }
      it { expect(video.infringes_copyright?).to be true }
    end

    context 'given fetching a status does not return rejectionReason "copyright"' do
      let(:attrs) { {status: {"uploadStatus"=>"rejected"}} }
      it { expect(video.infringes_copyright?).to be false }
    end
  end

  describe '#duplicate?' do
    context 'given fetching a status returns rejectionReason "duplicate"' do
      let(:attrs) { {status: {"uploadStatus"=>"rejected", "rejectionReason"=>"duplicate"}} }
      it { expect(video).to be_duplicate }
    end

    context 'given fetching a status does not return rejectionReason "duplicate"' do
      let(:attrs) { {status: {"uploadStatus"=>"rejected"}} }
      it { expect(video).not_to be_duplicate }
    end
  end

  describe '#inappropriate?' do
    context 'given fetching a status returns rejectionReason "inappropriate"' do
      let(:attrs) { {status: {"uploadStatus"=>"rejected", "rejectionReason"=>"inappropriate"}} }
      it { expect(video).to be_inappropriate }
    end

    context 'given fetching a status does not return rejectionReason "inappropriate"' do
      let(:attrs) { {status: {"uploadStatus"=>"rejected"}} }
      it { expect(video).not_to be_inappropriate }
    end
  end

  describe '#too_long?' do
    context 'given fetching a status returns rejectionReason "length"' do
      let(:attrs) { {status: {"uploadStatus"=>"rejected", "rejectionReason"=>"length"}} }
      it { expect(video).to be_too_long }
    end

    context 'given fetching a status does not return rejectionReason "length"' do
      let(:attrs) { {status: {"uploadStatus"=>"rejected"}} }
      it { expect(video).not_to be_too_long }
    end
  end

  describe '#violates_terms_of_use?' do
    context 'given fetching a status returns rejectionReason "termsOfUse"' do
      let(:attrs) { {status: {"uploadStatus"=>"rejected", "rejectionReason"=>"termsOfUse"}} }
      it { expect(video.violates_terms_of_use?).to be true }
    end

    context 'given fetching a status does not return rejectionReason "termsOfUse"' do
      let(:attrs) { {status: {"uploadStatus"=>"rejected"}} }
      it { expect(video.violates_terms_of_use?).to be false }
    end
  end

  describe '#infringes_trademark?' do
    context 'given fetching a status returns rejectionReason "trademark"' do
      let(:attrs) { {status: {"uploadStatus"=>"rejected", "rejectionReason"=>"trademark"}} }
      it { expect(video.infringes_trademark?).to be true }
    end

    context 'given fetching a status does not return rejectionReason "trademark"' do
      let(:attrs) { {status: {"uploadStatus"=>"rejected"}} }
      it { expect(video.infringes_trademark?).to be false }
    end
  end

  describe '#belongs_to_closed_account?' do
    context 'given fetching a status returns rejectionReason "uploaderAccountClosed"' do
      let(:attrs) { {status: {"uploadStatus"=>"rejected", "rejectionReason"=>"uploaderAccountClosed"}} }
      it { expect(video.belongs_to_closed_account?).to be true }
    end

    context 'given fetching a status does not return rejectionReason "uploaderAccountClosed"' do
      let(:attrs) { {status: {"uploadStatus"=>"rejected"}} }
      it { expect(video.belongs_to_closed_account?).to be false }
    end
  end

  describe '#belongs_to_suspended_account?' do
    context 'given fetching a status returns rejectionReason "uploaderAccountSuspended"' do
      let(:attrs) { {status: {"uploadStatus"=>"rejected", "rejectionReason"=>"uploaderAccountSuspended"}} }
      it { expect(video.belongs_to_suspended_account?).to be true }
    end

    context 'given fetching a status does not return rejectionReason "uploaderAccountSuspended"' do
      let(:attrs) { {status: {"uploadStatus"=>"rejected"}} }
      it { expect(video.belongs_to_suspended_account?).to be false }
    end
  end

  describe '#scheduled_at and #scheduled' do
    context 'given fetching a status returns "publishAt"' do
      let(:attrs) { {status: {"uploadStatus"=>"uploaded", "privacyStatus"=>"private", "publishAt"=>"2014-04-22T19:14:49.000Z"}} }
      it { expect(video).to be_scheduled }
      it { expect(video.scheduled_at.year).to be 2014 }
    end

    context 'given fetching a status does not returns "publishAt"' do
      let(:attrs) { {status: {"uploadStatus"=>"uploaded", "privacyStatus"=>"private"}} }
      it { expect(video).not_to be_scheduled }
      it { expect(video.scheduled_at).not_to be }
    end
  end

  describe '#licensed_as_creative_commons?' do
    context 'given fetching a status returns license "creativeCommon"' do
      let(:attrs) { {status: {"uploadStatus"=>"uploaded", "license"=>"creativeCommon"}} }
      it { expect(video).to be_licensed_as_creative_commons }
    end

    context 'given fetching a status does not return license "creativeCommon"' do
      let(:attrs) { {status: {"uploadStatus"=>"uploaded"}} }
      it { expect(video).not_to be_licensed_as_creative_commons }
    end
  end

  describe '#licensed_as_standard_youtube?' do
    context 'given fetching a status returns license "youtube"' do
      let(:attrs) { {status: {"uploadStatus"=>"uploaded", "license"=>"youtube"}} }
      it { expect(video).to be_licensed_as_standard_youtube }
    end

    context 'given fetching a status does not return license "youtube"' do
      let(:attrs) { {status: {"uploadStatus"=>"uploaded"}} }
      it { expect(video).not_to be_licensed_as_standard_youtube }
    end
  end

  describe '#embeddable?' do
    context 'given fetching a status returns "embeddable" true' do
      let(:attrs) { {status: {"uploadStatus"=>"uploaded", "embeddable"=>true}} }
      it { expect(video).to be_embeddable }
    end

    context 'given fetching a status returns "embeddable" false' do
      let(:attrs) { {status: {"uploadStatus"=>"uploaded", "embeddable"=>false}} }
      it { expect(video).not_to be_embeddable }
    end
  end

  describe '#has_public_stats_viewable?' do
    context 'given fetching a status returns "publicStatsViewable" true' do
      let(:attrs) { {status: {"publicStatsViewable"=>true}} }
      it { expect(video).to have_public_stats_viewable }
    end

    context 'given fetching a status returns "publicStatsViewable" false' do
      let(:attrs) { {status: {"publicStatsViewable"=>false}} }
      it { expect(video).not_to have_public_stats_viewable }
    end
  end

  describe '#stereoscopic?' do
    context 'given a 3D video' do
      let(:attrs) { {content_details: {"dimension"=>"3d"}} }
      it { expect(video).to be_stereoscopic }
    end

    context 'given a 2D video' do
      let(:attrs) { {content_details: {"dimension"=>"2d"}} }
      it { expect(video).not_to be_stereoscopic }
    end
  end

  describe '#hd?' do
    context 'given a high-definition video' do
      let(:attrs) { {content_details: {"definition"=>"hd"}} }
      it { expect(video).to be_hd }
    end

    context 'given a standard-definition video' do
      let(:attrs) { {content_details: {"definition"=>"sd"}} }
      it { expect(video).not_to be_hd }
    end
  end

  describe '#captioned?' do
    context 'given a video with captions' do
      let(:attrs) { {content_details: {"caption"=>"true"}} }
      it { expect(video).to be_captioned }
    end

    context 'given a video without captions' do
      let(:attrs) { {content_details: {"caption"=>"false"}} }
      it { expect(video).not_to be_captioned }
    end
  end

  describe '#licensed?' do
    context 'given a video with licensed content' do
      let(:attrs) { {content_details: {"licensedContent"=>true}} }
      it { expect(video).to be_licensed }
    end

    context 'given a video without licensed content' do
      let(:attrs) { {content_details: {"licensedContent"=>false}} }
      it { expect(video).not_to be_licensed }
    end
  end

  describe '#age_restricted?' do
    context 'given a video with age restricted content' do
      let(:attrs) { {content_details: {"contentRating"=>{"ytRating"=>"ytAgeRestricted"}}} }
      it { expect(video).to be_age_restricted }
    end

    context 'given a video without age restricted content' do
      let(:attrs) { {content_details: {}} }
      it { expect(video).not_to be_age_restricted }
    end

    context 'given a video with a content rating but not ytRating' do
      let(:attrs) { {content_details: {"contentRating"=>{"acbRating": "PG"}}} }
      it { expect(video).not_to be_age_restricted }
    end
  end

  describe '#made_for_kids?' do
    context 'given fetching a status returns madeForKids true' do
      let(:attrs) { {status: {"madeForKids"=>true}} }
      it { expect(video).to be_made_for_kids }
    end

    context 'given fetching a status returns madeForKids false' do
      let(:attrs) { {status: {"madeForKids"=>false}} }
      it { expect(video).not_to be_made_for_kids }
    end
  end

  describe '#self_declared_made_for_kids?' do
    context 'given fetching a status returns selfDeclaredMadeForKids true' do
      let(:attrs) { {status: {"selfDeclaredMadeForKids"=>true}} }
      it { expect(video).to be_self_declared_made_for_kids }
    end

    context 'given fetching a status returns selfDeclaredMadeForKids false' do
      let(:attrs) { {status: {"selfDeclaredMadeForKids"=>false}} }
      it { expect(video).not_to be_self_declared_made_for_kids }
    end
  end

  describe '#file_size' do
    context 'given a video with fileSize' do
      let(:attrs) { {file_details: {"fileSize"=>"8000000"}} }
      it { expect(video.file_size).to be 8_000_000 }
    end
  end

  describe '#file_type' do
    context 'given a video with fileType' do
      let(:attrs) { {file_details: {"fileType"=>"video"}} }
      it { expect(video.file_type).to eq 'video' }
    end
  end

  describe '#container' do
    context 'given a video with container' do
      let(:attrs) { {file_details: {"container"=>"mov"}} }
      it { expect(video.container).to eq 'mov' }
    end
  end

  describe '#actual_start_time' do
    context 'given a non-live streaming video' do
      let(:attrs) { {live_streaming_details: {}} }
      it { expect(video.actual_start_time).to be_nil }
    end

    context 'given a live streaming video that has not started yet' do
      let(:attrs) { {live_streaming_details: {"scheduledStartTime"=>"2017-07-10T00:00:00.000Z"}} }
      it { expect(video.actual_start_time).to be_nil }
    end

    context 'given a live streaming video that has started' do
      let(:attrs) { {live_streaming_details: {"actualStartTime"=>"2014-08-01T17:48:40.678Z"}} }
      it { expect(video.actual_start_time.year).to be 2014 }
    end
  end

  describe '#actual_end_time' do
    context 'given a non-live streaming video' do
      let(:attrs) { {live_streaming_details: {}} }
      it { expect(video.actual_end_time).to be_nil }
    end

    context 'given a live streaming video that has not ended yet' do
      let(:attrs) { {live_streaming_details: {"scheduledStartTime"=>"2017-07-10T00:00:00.000Z"}} }
      it { expect(video.actual_end_time).to be_nil }
    end

    context 'given a live streaming video that has ended' do
      let(:attrs) { {live_streaming_details: {"actualEndTime"=>"2014-08-01T17:48:40.678Z"}} }
      it { expect(video.actual_end_time.year).to be 2014 }
    end
  end

  describe '#scheduled_start_time' do
    context 'given a non-live streaming video' do
      let(:attrs) { {live_streaming_details: {}} }
      it { expect(video.scheduled_start_time).to be_nil }
    end

    context 'given a live streaming video' do
      let(:attrs) { {live_streaming_details: {"scheduledStartTime"=>"2017-07-10T00:00:00.000Z"}} }
      it { expect(video.scheduled_start_time.year).to be 2017 }
    end
  end

  describe '#scheduled_end_time' do
    context 'given a non-live streaming video' do
      let(:attrs) { {live_streaming_details: {}} }
      it { expect(video.scheduled_end_time).to be_nil }
    end

    context 'given a live streaming video that broadcasts indefinitely' do
      let(:attrs) { {live_streaming_details: {"scheduledStartTime"=>"2017-07-10T00:00:00.000Z"}} }
      it { expect(video.scheduled_end_time).to be_nil }
    end

    context 'given a live streaming video with a scheduled ednd' do
      let(:attrs) { {live_streaming_details: {"scheduledEndTime"=>"2014-08-01T17:48:40.678Z"}} }
      it { expect(video.scheduled_end_time.year).to be 2014 }
    end
  end

  describe '#concurrent_viewers' do
    context 'given a non-live streaming video' do
      let(:attrs) { {live_streaming_details: {}} }
      it { expect(video.concurrent_viewers).to be_nil }
    end

    context 'given a current live streaming video with viewers' do
      let(:attrs) { {live_streaming_details: {"concurrentViewers"=>"1"}} }
      it { expect(video.concurrent_viewers).to be 1 }
    end

    context 'given a past live streaming video' do
      let(:attrs) { {live_streaming_details: {"actualEndTime"=>"2013-08-01T17:48:40.678Z"}} }
      it { expect(video.concurrent_viewers).to be_nil }
    end
  end

  describe '#view_count' do
    context 'given a video with views' do
      let(:attrs) { {statistics: { "viewCount"=>"123"}} }
      it { expect(video.view_count).to be 123 }
    end
  end

  describe '#comment_count' do
    context 'given a video with comments' do
      let(:attrs) { {statistics: { "commentCount"=>"45"}} }
      it { expect(video.comment_count).to be 45 }
    end
  end

  describe '#like_count' do
    context 'given a video with likes' do
      let(:attrs) { {statistics: { "likeCount"=>"6"}} }
      it { expect(video.like_count).to be 6 }
    end
  end

  describe '#dislike_count' do
    context 'given a video with dislikes' do
      let(:attrs) { {statistics: { "dislikeCount"=>"9"}} }
      it { expect(video.dislike_count).to be 9 }
    end
  end

  describe '#favorite_count' do
    context 'given a video with favorites' do
      let(:attrs) { {statistics: { "favoriteCount"=>"44"}} }
      it { expect(video.favorite_count).to be 44 }
    end
  end

  describe '#embed_html' do
    context 'given a video with embedHtml' do
      let(:html) { "<iframe type='text/html' src='http://www.youtube.com/embed/BPNYv0vd78A' width='640' height='360' frameborder='0' allowfullscreen='true'/>" }
      let(:attrs) { {player: {"embedHtml"=>html}} }
      it { expect(video.embed_html).to be html }
    end
  end

  describe '#statistics_set' do
    context 'given fetching a video returns statistics' do
      let(:attrs) { {statistics: {"viewCount"=>"202"}} }
      it { expect(video.statistics_set).to be_a Yt::StatisticsSet }
    end
  end

  describe '#content_details' do
    context 'given fetching a video returns content details' do
      let(:attrs) { {content_details: {"definition"=>"hd"}} }
      it { expect(video.content_detail).to be_a Yt::ContentDetail }
    end
  end

  describe '#update' do
    let(:attrs) { {id: '9bZkp7q19f0', snippet: {'title'=>'old'}} }
    before { expect(video).to receive(:do_update).and_yield 'snippet'=>{'title'=>'new'} }

    it { expect(video.update title: 'new').to be true }
    it { expect{video.update title: 'new'}.to change{video.title} }
  end

  describe '#delete' do
    let(:attrs) { {id: 'video-id'} }

    context 'given an existing video' do
      before { expect(video).to receive(:do_delete).and_yield }

      it { expect(video.delete).to be true }
      it { expect{video.delete}.to change{video.exists?} }
    end
  end
end
