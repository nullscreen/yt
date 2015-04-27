require 'spec_helper'
require 'yt/models/status'

describe Yt::Status do
  subject(:status) { Yt::Status.new data: data }

  describe '#data' do
    let(:data) { {"key"=>"value"} }
    specify 'returns the data the status was initialized with' do
      expect(status.data).to eq data
    end
  end

  describe '#public?' do
    context 'given fetching a status returns privacyStatus "public"' do
      let(:data) { {"privacyStatus"=>"public"} }
      it { expect(status).to be_public }
    end

    context 'given fetching a status does not return privacyStatus "public"' do
      let(:data) { {} }
      it { expect(status).not_to be_public }
    end
  end

  describe '#private?' do
    context 'given fetching a status returns privacyStatus "private"' do
      let(:data) { {"privacyStatus"=>"private"} }
      it { expect(status).to be_private }
    end

    context 'given fetching a status does not return privacyStatus "private"' do
      let(:data) { {} }
      it { expect(status).not_to be_private }
    end
  end

  describe '#unlisted?' do
    context 'given fetching a status returns privacyStatus "unlisted"' do
      let(:data) { {"privacyStatus"=>"unlisted"} }
      it { expect(status).to be_unlisted }
    end

    context 'given fetching a status does not return privacyStatus "unlisted"' do
      let(:data) { {} }
      it { expect(status).not_to be_unlisted }
    end
  end

  describe '#deleted?' do
    context 'given fetching a status returns uploadStatus "deleted"' do
      let(:data) { {"uploadStatus"=>"deleted"} }
      it { expect(status).to be_deleted }
    end

    context 'given fetching a status does not return uploadStatus "deleted"' do
      let(:data) { {"uploadStatus"=>"uploaded"} }
      it { expect(status).not_to be_deleted }
    end
  end

  describe '#failed?' do
    context 'given fetching a status returns uploadStatus "failed"' do
      let(:data) { {"uploadStatus"=>"failed"} }
      it { expect(status).to be_failed }
    end

    context 'given fetching a status does not return uploadStatus "failed"' do
      let(:data) { {"uploadStatus"=>"uploaded"} }
      it { expect(status).not_to be_failed }
    end
  end

  describe '#processed?' do
    context 'given fetching a status returns uploadStatus "processed"' do
      let(:data) { {"uploadStatus"=>"processed"} }
      it { expect(status).to be_processed }
    end

    context 'given fetching a status does not return uploadStatus "processed"' do
      let(:data) { {"uploadStatus"=>"uploaded"} }
      it { expect(status).not_to be_processed }
    end
  end

  describe '#rejected?' do
    context 'given fetching a status returns uploadStatus "rejected"' do
      let(:data) { {"uploadStatus"=>"rejected"} }
      it { expect(status).to be_rejected }
    end

    context 'given fetching a status does not return uploadStatus "rejected"' do
      let(:data) { {"uploadStatus"=>"uploaded"} }
      it { expect(status).not_to be_rejected }
    end
  end

  describe '#uploaded?' do
    context 'given fetching a status returns uploadStatus "uploaded"' do
      let(:data) { {"uploadStatus"=>"uploaded"} }
      it { expect(status).to be_uploading }
    end

    context 'given fetching a status does not return uploadStatus "uploaded"' do
      let(:data) { {"uploadStatus"=>"failed"} }
      it { expect(status).not_to be_uploading }
    end
  end

  describe '#uses_unsupported_codec?' do
    context 'given fetching a status returns failureReason "codec"' do
      let(:data) { {"uploadStatus"=>"failed", "failureReason"=>"codec"} }
      it { expect(status.uses_unsupported_codec?).to be true }
    end

    context 'given fetching a status does not return failureReason "codec"' do
      let(:data) { {"uploadStatus"=>"failed"} }
      it { expect(status.uses_unsupported_codec?).to be false }
    end
  end

  describe '#conversion_failed?' do
    context 'given fetching a status returns failureReason "conversion"' do
      let(:data) { {"uploadStatus"=>"failed", "failureReason"=>"conversion"} }
      it { expect(status).to have_failed_conversion }
    end

    context 'given fetching a status does not return failureReason "conversion"' do
      let(:data) { {"uploadStatus"=>"failed"} }
      it { expect(status).not_to have_failed_conversion }
    end
  end

  describe '#empty_file?' do
    context 'given fetching a status returns failureReason "emptyFile"' do
      let(:data) { {"uploadStatus"=>"failed", "failureReason"=>"emptyFile"} }
      it { expect(status).to be_empty }
    end

    context 'given fetching a status does not return failureReason "emptyFile"' do
      let(:data) { {"uploadStatus"=>"failed"} }
      it { expect(status).not_to be_empty }
    end
  end

  describe '#invalid_file?' do
    context 'given fetching a status returns failureReason "invalidFile"' do
      let(:data) { {"uploadStatus"=>"failed", "failureReason"=>"invalidFile"} }
      it { expect(status).to be_invalid }
    end

    context 'given fetching a status does not return failureReason "invalidFile"' do
      let(:data) { {"uploadStatus"=>"failed"} }
      it { expect(status).not_to be_invalid }
    end
  end

  describe '#too_small?' do
    context 'given fetching a status returns failureReason "tooSmall"' do
      let(:data) { {"uploadStatus"=>"failed", "failureReason"=>"tooSmall"} }
      it { expect(status).to be_too_small }
    end

    context 'given fetching a status does not return failureReason "tooSmall"' do
      let(:data) { {"uploadStatus"=>"failed"} }
      it { expect(status).not_to be_too_small }
    end
  end

  describe '#upload_aborted?' do
    context 'given fetching a status returns failureReason "uploadAborted"' do
      let(:data) { {"uploadStatus"=>"failed", "failureReason"=>"uploadAborted"} }
      it { expect(status).to be_aborted }
    end

    context 'given fetching a status does not return failureReason "uploadAborted"' do
      let(:data) { {"uploadStatus"=>"failed"} }
      it { expect(status).not_to be_aborted }
    end
  end

  describe '#claimed?' do
    context 'given fetching a status returns rejectionReason "claim"' do
      let(:data) { {"uploadStatus"=>"rejected", "rejectionReason"=>"claim"} }
      it { expect(status).to be_claimed }
    end

    context 'given fetching a status does not return rejectionReason "claim"' do
      let(:data) { {"uploadStatus"=>"rejected"} }
      it { expect(status).not_to be_claimed }
    end
  end

  describe '#infringes_copyright?' do
    context 'given fetching a status returns rejectionReason "copyright"' do
      let(:data) { {"uploadStatus"=>"rejected", "rejectionReason"=>"copyright"} }
      it { expect(status.infringes_copyright?).to be true }
    end

    context 'given fetching a status does not return rejectionReason "copyright"' do
      let(:data) { {"uploadStatus"=>"rejected"} }
      it { expect(status.infringes_copyright?).to be false }
    end
  end

  describe '#duplicate?' do
    context 'given fetching a status returns rejectionReason "duplicate"' do
      let(:data) { {"uploadStatus"=>"rejected", "rejectionReason"=>"duplicate"} }
      it { expect(status).to be_duplicate }
    end

    context 'given fetching a status does not return rejectionReason "duplicate"' do
      let(:data) { {"uploadStatus"=>"rejected"} }
      it { expect(status).not_to be_duplicate }
    end
  end

  describe '#inappropriate?' do
    context 'given fetching a status returns rejectionReason "inappropriate"' do
      let(:data) { {"uploadStatus"=>"rejected", "rejectionReason"=>"inappropriate"} }
      it { expect(status).to be_inappropriate }
    end

    context 'given fetching a status does not return rejectionReason "inappropriate"' do
      let(:data) { {"uploadStatus"=>"rejected"} }
      it { expect(status).not_to be_inappropriate }
    end
  end

  describe '#too_long?' do
    context 'given fetching a status returns rejectionReason "length"' do
      let(:data) { {"uploadStatus"=>"rejected", "rejectionReason"=>"length"} }
      it { expect(status).to be_too_long }
    end

    context 'given fetching a status does not return rejectionReason "length"' do
      let(:data) { {"uploadStatus"=>"rejected"} }
      it { expect(status).not_to be_too_long }
    end
  end

  describe '#violates_terms_of_use?' do
    context 'given fetching a status returns rejectionReason "termsOfUse"' do
      let(:data) { {"uploadStatus"=>"rejected", "rejectionReason"=>"termsOfUse"} }
      it { expect(status.violates_terms_of_use?).to be true }
    end

    context 'given fetching a status does not return rejectionReason "termsOfUse"' do
      let(:data) { {"uploadStatus"=>"rejected"} }
      it { expect(status.violates_terms_of_use?).to be false }
    end
  end

  describe '#infringes_trademark?' do
    context 'given fetching a status returns rejectionReason "trademark"' do
      let(:data) { {"uploadStatus"=>"rejected", "rejectionReason"=>"trademark"} }
      it { expect(status.infringes_trademark?).to be true }
    end

    context 'given fetching a status does not return rejectionReason "trademark"' do
      let(:data) { {"uploadStatus"=>"rejected"} }
      it { expect(status.infringes_trademark?).to be false }
    end
  end

  describe '#belongs_to_closed_account?' do
    context 'given fetching a status returns rejectionReason "uploaderAccountClosed"' do
      let(:data) { {"uploadStatus"=>"rejected", "rejectionReason"=>"uploaderAccountClosed"} }
      it { expect(status.belongs_to_closed_account?).to be true }
    end

    context 'given fetching a status does not return rejectionReason "uploaderAccountClosed"' do
      let(:data) { {"uploadStatus"=>"rejected"} }
      it { expect(status.belongs_to_closed_account?).to be false }
    end
  end

  describe '#belongs_to_suspended_account?' do
    context 'given fetching a status returns rejectionReason "uploaderAccountSuspended"' do
      let(:data) { {"uploadStatus"=>"rejected", "rejectionReason"=>"uploaderAccountSuspended"} }
      it { expect(status.belongs_to_suspended_account?).to be true }
    end

    context 'given fetching a status does not return rejectionReason "uploaderAccountSuspended"' do
      let(:data) { {"uploadStatus"=>"rejected"} }
      it { expect(status.belongs_to_suspended_account?).to be false }
    end
  end

  describe '#scheduled_at and #scheduled' do
    context 'given fetching a status returns "publishAt"' do
      let(:data) { {"uploadStatus"=>"uploaded", "privacyStatus"=>"private", "publishAt"=>"2014-04-22T19:14:49.000Z"} }
      it { expect(status).to be_scheduled }
      it { expect(status.scheduled_at.year).to be 2014 }
    end

    context 'given fetching a status does not returns "publishAt"' do
      let(:data) { {"uploadStatus"=>"uploaded", "privacyStatus"=>"private"} }
      it { expect(status).not_to be_scheduled }
      it { expect(status.scheduled_at).not_to be }
    end
  end

  describe '#licensed_as_creative_commons?' do
    context 'given fetching a status returns license "creativeCommon"' do
      let(:data) { {"uploadStatus"=>"uploaded", "license"=>"creativeCommon"} }
      it { expect(status).to be_licensed_as_creative_commons }
    end

    context 'given fetching a status does not return license "creativeCommon"' do
      let(:data) { {"uploadStatus"=>"uploaded"} }
      it { expect(status).not_to be_licensed_as_creative_commons }
    end
  end

  describe '#licensed_as_standard_youtube?' do
    context 'given fetching a status returns license "youtube"' do
      let(:data) { {"uploadStatus"=>"uploaded", "license"=>"youtube"} }
      it { expect(status).to be_licensed_as_standard_youtube }
    end

    context 'given fetching a status does not return license "youtube"' do
      let(:data) { {"uploadStatus"=>"uploaded"} }
      it { expect(status).not_to be_licensed_as_standard_youtube }
    end
  end

  describe '#embeddable?' do
    context 'given fetching a status returns "embeddable" true' do
      let(:data) { {"uploadStatus"=>"uploaded", "embeddable"=>true} }
      it { expect(status).to be_embeddable }
    end

    context 'given fetching a status returns "embeddable" false' do
      let(:data) { {"uploadStatus"=>"uploaded", "embeddable"=>false} }
      it { expect(status).not_to be_embeddable }
    end
  end

  describe '#has_public_stats_viewable?' do
    context 'given fetching a status returns "publicStatsViewable" true' do
      let(:data) { {"publicStatsViewable"=>true} }
      it { expect(status).to have_public_stats_viewable }
    end

    context 'given fetching a status returns "publicStatsViewable" false' do
      let(:data) { {"publicStatsViewable"=>false} }
      it { expect(status).not_to have_public_stats_viewable }
    end
  end
end