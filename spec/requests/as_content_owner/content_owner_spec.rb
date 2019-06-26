require 'spec_helper'
require 'yt/models/content_owner'
require 'yt/models/match_policy'

describe Yt::ContentOwner, :partner do
  describe '.partnered_channels' do
    let(:partnered_channels) { $content_owner.partnered_channels }

    specify '.first' do
      expect(partnered_channels.first).to be_a Yt::Channel
    end

    specify '.size', :ruby2 do
      expect(partnered_channels.size).to be > 0
    end
  end

  describe '.videos' do
    let(:video) { $content_owner.videos.where(order: 'viewCount').first }

    specify 'returns the videos in network with the content owner with their tags and category ID' do
      expect(video).to be_a Yt::Video
      expect(video.tags).not_to be_empty
      expect(video.category_id).not_to be_nil
    end

    describe '.includes(:snippet)' do
      let(:video) { $content_owner.videos.includes(:snippet).first }

      specify 'eager-loads the *full* snippet of each video' do
        expect(video.instance_variable_defined? :@snippet).to be true
        expect(video.channel_title).to be
        expect(video.snippet).to be_complete
      end
    end

    describe '.includes(:statistics, :status)' do
      let(:video) { $content_owner.videos.includes(:statistics, :status).first }

      specify 'eager-loads the statistics and status of each video' do
        expect(video.instance_variable_defined? :@statistics_set).to be true
        expect(video.instance_variable_defined? :@status).to be true
      end
    end

    describe '.includes(:content_details)' do
      let(:video) { $content_owner.videos.includes(:content_details).first }

      specify 'eager-loads the statistics of each video' do
        expect(video.instance_variable_defined? :@content_detail).to be true
      end
    end

    describe '.includes(:claim)' do
      let(:videos) { $content_owner.videos.includes(:claim) }
      let(:video_with_claim) { videos.find{|v| v.claim.present?} }

      specify 'eager-loads the claim of each video and its asset' do
        expect(video_with_claim.claim).to be_a Yt::Claim
        expect(video_with_claim.claim.id).to be_a String
        expect(video_with_claim.claim.video_id).to eq video_with_claim.id
        expect(video_with_claim.claim.asset).to be_a Yt::Asset
        expect(video_with_claim.claim.asset.id).to be_a String
      end
    end
  end

  describe '.video_groups' do
    let(:video_group) { $content_owner.video_groups.first }

    specify 'returns the first video-group created by the account' do
      expect(video_group).to be_a Yt::VideoGroup
      expect(video_group.title).to be_a String
      expect(video_group.item_count).to be_an Integer
      expect(video_group.published_at).to be_a Time
    end

    specify 'allows to run reports against each video-group' do
      expect(video_group.views).to be
    end
  end

  describe 'claims' do
    let(:asset_id) { ENV['YT_TEST_PARTNER_ASSET_ID'] }
    let(:video_id) { ENV['YT_TEST_PARTNER_CLAIMABLE_VIDEO_ID'] }
    let(:options) { {asset_id: asset_id, video_id: video_id, content_type: 'audiovisual'} }

    context 'given an existing policy ID' do
      let(:policy_id) { ENV['YT_TEST_PARTNER_POLICY_ID'] }
      let(:params) { options.merge policy_id: policy_id }

      specify 'can be added' do
        begin
          expect($content_owner.create_claim params).to be_a Yt::Claim
        rescue Yt::Errors::RequestError => e
          # @note: Every time this test runs, a claim is inserted for the same
          #   video and asset, but YouTube does not allow this, and responds with
          #   an error message like "Video is already claimed. Existing claims
          #   on this video: AbCdEFg1234".
          #   For the sake of testing, we delete the duplicate and try again.
          raise unless e.reasons.include? 'alreadyClaimed'
          id = e.kind['message'].match(/this video: (.*?)$/) {|re| re[1]}
          Yt::Claim.new(id: id, auth: $content_owner).delete
          expect($content_owner.create_claim params).to be_a Yt::Claim
        end
      end
    end

    context 'given a new policy' do
      let(:params) { options.merge policy: {rules: [action: :block]} }

      specify 'can be added' do
        begin
          expect($content_owner.create_claim params).to be_a Yt::Claim
        rescue Yt::Errors::RequestError => e
          # @note: Every time this test runs, a claim is inserted for the same
          #   video and asset, but YouTube does not allow this, and responds with
          #   an error message like "Video is already claimed. Existing claims
          #   on this video: AbCdEFg1234".
          #   For the sake of testing, we delete the duplicate and try again.
          raise unless e.reasons.include? 'alreadyClaimed'
          id = e.kind['message'].match(/this video: (.*?)$/) {|re| re[1]}
          Yt::Claim.new(id: id, auth: $content_owner).delete
          expect($content_owner.create_claim params).to be_a Yt::Claim
        end
      end
    end
  end

  describe '.claims' do
    describe 'given the content owner has claims' do
      let(:claim) { $content_owner.claims.first }

      it 'returns valid metadata' do
        expect(claim.id).to be_a String
        expect(claim.asset_id).to be_a String
        expect(claim.video_id).to be_a String
        expect(claim.status).to be_a String
        expect(claim.content_type).to be_a String
        expect(claim.created_at).to be_a Time
        expect(claim).not_to be_third_party
      end
    end

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
        let(:asset_id) { ENV['YT_TEST_PARTNER_ASSET_WITH_CLAIM_ID'] }
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

  describe 'references' do
    let(:claim_id) { ENV['YT_TEST_PARTNER_REFERENCE_CLAIM_ID'] }
    let(:content_type) { ENV['YT_TEST_PARTNER_REFERENCE_CONTENT_TYPE'] }
    let(:params) { {claim_id: claim_id, content_type: content_type} }

    specify 'can be added' do
      begin
        expect($content_owner.create_reference params).to be_a Yt::Reference
      rescue Yt::Errors::RequestError => e
        # @note: Every time this test runs, a reference is inserted for the
        #   same claim, but YouTube does not allow this, and responds with an
        #   error message like "You attempted to create a reference using the
        #   content of a previously claimed video, but such a reference already
        #   exists. The ID of the duplicate reference is xhpACYclOdc."
        #   For the sake of testing, we delete the duplicate and try again.
        # @note: Deleting a reference does not work if the reference status is
        #   "checking" or "pending" and it can take up to 4 minutes for a new
        #   reference to be checked. The +sleep+ statement takes care of this
        #   case in the only way allowed by YouTube: sadly waiting.
        raise unless e.reasons.include? 'referenceAlreadyExists'
        id = e.kind['message'].match(/reference is (.*?)\.$/) {|re| re[1]}
        sleep 15 until Yt::Reference.new(id: id, auth: $content_owner).delete
        expect($content_owner.create_reference params).to be_a Yt::Reference
      end
    end
  end

  describe '.references' do
    describe '.where(id: reference_id)' do
      let(:reference) { $content_owner.references.where(id: reference_id).first }

      context 'given the ID of a reference administered by the content owner' do
        let(:reference_id) { ENV['YT_TEST_PARTNER_REFERENCE_ID'] }

        it 'returns valid metadata' do
          expect(reference.id).to be_a String
          expect(reference.asset_id).to be_a String
          expect(reference.length).to be_a Float
          expect(reference.video_id).to be_a String
          expect(reference.claim_id).to be_a String
          expect(reference.audioswap_enabled?).to be_in [true, false]
          expect(reference.ignore_fp_match?).to be_in [true, false]
          expect(reference.urgent?).to be_in [true, false]
          expect(reference.status).to be_a String
          expect(reference.content_type).to be_a String
        end
      end

      context 'given an unknown reference ID' do
        let(:reference_id) { '--not-a-matching-reference-id--' }
        it { expect(reference).not_to be }
      end
    end

    describe '.upload_reference_file' do
      let(:asset) { Yt::Asset.new id: ENV['YT_TEST_PARTNER_ASSET_ID'], auth: $content_owner }
      let(:match_policy) { Yt::MatchPolicy.new asset_id: ENV['YT_TEST_PARTNER_ASSET_ID'], auth: $content_owner }

      let(:upload_params) { {asset_id: asset.id, content_type: 'video'} }
      let(:reference) { $content_owner.upload_reference_file path_or_url, upload_params }
      after { reference.delete }

      before do
        asset.ownership.update(assetId: asset.id) && asset.ownership.obtain!
        match_policy.update policy_id: ENV['YT_TEST_PARTNER_POLICY_ID']
      end

      context 'given the URL of a remote video file' do
        let(:path_or_url) { ENV['YT_REMOTE_VIDEO_URL'] }

        it { expect(reference).to be_a Yt::Reference }
      end
    end
  end

  describe '.policies' do
    describe 'given the content owner has policies' do
      let(:policy) { $content_owner.policies.first }
      let(:rule) { policy.rules.first }

      it 'returns valid metadata' do
        expect(policy.id).to be_a String
        expect(policy.name).to be_a String
        expect(policy.updated_at).to be_a Time
        expect(rule.action).to  be_a String
        expect(rule.included_territories).to be_an Array
        expect(rule.excluded_territories).to be_an Array
        expect(rule.match_duration).to be_an Array
        expect(rule.match_percent).to be_an Array
        expect(rule.reference_duration).to be_an Array
        expect(rule.reference_percent).to be_an Array
      end
    end

    describe '.where(id: policy_id) given an unknown policy ID' do
      let(:policy) { $content_owner.policies.where(id: policy_id).first }
      let(:policy_id) { '--not-a-matching-reference-id--' }
      it { expect(policy).not_to be }
    end
  end

  describe '.assets' do
    describe 'given the content owner has assets' do
      let(:asset) { $content_owner.assets.first }

      it 'returns valid asset' do
        expect(asset.id).to be_a String
        expect(asset.type).to be_a String
        expect(asset.title).to be_a String
        expect(asset.custom_id).to be_a String
      end
    end
  end

  # @note: The following test works, but YouTube API endpoint to mark
  #   an asset as 'invalid' (soft-delete) does not work, and apparently
  #   there is no way to update the status of a asset.
  #   Therefore, the test is commented out, otherwise a new asset would
  #   be created every time the test is run.
  # describe 'assets can be added' do
  #   let(:params) { {type: 'web', metadata_mine: {title: "Test Asset Title"}} }
  #   before { @asset = $content_owner.create_asset params }
  #   after { @asset.delete } # This does not seem to work
  #   it { expect(@asset).to be_a Yt::Asset }
  # end

  describe '.bulk_report_jobs' do
    describe 'given the content owner has bulk report jobs' do
      let(:job) { $content_owner.bulk_report_jobs.first }

      it 'returns valid job' do
        expect(job.id).to be_a String
        expect(job.report_type_id).to be_a String
      end
    end
  end

  describe '.content_owners' do
    describe '.where(id: content_owner_ids)' do
      let(:content_owner_a) { $content_owner.content_owners.where(id: content_owner_ids).first }

      context 'given valid content owner names' do
        let(:content_owner_ids) { 'a8MUrfnFEzBX3uLQepd5mg,GIfKLveZoYetfSFgvG2VtQ' }

        it 'returns valid content owner' do
          expect(content_owner_a.display_name).to be_a String
        end
      end

      context 'given an unknown content owner ID' do
        let(:content_owner_ids) { '--not-a-valid-owner-id--' }
        it { expect(content_owner_a).not_to be }
      end
    end
  end
end
