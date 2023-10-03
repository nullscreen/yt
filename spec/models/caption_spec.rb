require 'spec_helper'
require 'yt/models/caption'

describe Yt::Caption do
  subject(:caption) { Yt::Caption.new attrs }

  context 'given fetching a caption' do
    let(:attrs) {
      {
        id: "AUieDaYVR2rtPo9BP64ZH77P_-MQOdT0tq2U8jUF08csZ3-UDow",
        snippet: {
          "videoId"=>"8ompJkDKEEI",
          "lastUpdated"=>"2023-09-26T11:04:48.779642Z",
          "trackKind"=>"asr",
          "language"=>"es",
          "name"=>"",
          "audioTrackType"=>"unknown",
          "isCC"=>false,
          "isLarge"=>false,
          "isEasyReader"=>false,
          "isDraft"=>false,
          "isAutoSynced"=>false,
          "status"=>"serving"
        }
      }
    }
    it 'returning attributes' do
      expect(caption.video_id).to eq '8ompJkDKEEI'
      expect(caption.last_updated.to_date.to_s).to eq '2023-09-26'
      expect(caption.language).to eq 'es'
      expect(caption.name).to eq ''
      expect(caption.status).to eq 'serving'
      expect(caption.id).to eq 'AUieDaYVR2rtPo9BP64ZH77P_-MQOdT0tq2U8jUF08csZ3-UDow'
    end
  end
end
