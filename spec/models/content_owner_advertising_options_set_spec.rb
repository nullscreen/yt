require 'spec_helper'
require 'yt/models/content_owner_advertising_options_set'

describe Yt::ContentOwnerAdvertisingOptionsSet do
  subject(:advertising_options) { Yt::ContentOwnerAdvertisingOptionsSet.new data: data }

  describe '#id' do
    context 'given feteching a set of advertising options' do
      let(:data){ {"id" => "AO123456789"} }
      it{ expect(advertising_options.id).to eq "AO123456789" }
    end
  end

  describe '#allowed_options' do
    context 'given fetching a set of advertising options returns allowed options' do
      let(:data){
        { "allowedOptions" => {
            "adsOnEmbeds" => true,
            "licAdFormats" => ['long', 'overlay']
          }
        }
      }

      it { expect(advertising_options.allowed_options.ads_on_embeds).to be true }
    end
  end

  describe '#claimed_video_options' do
    context 'given fetching a set of advertising options returns claimed video options' do
      let(:data) {
        { "claimedVideoOptions"=>{
            "newVideoDefaults" => ['long', 'overlay'],
            "channelOverride" => true
          }
        }
      }
      it { expect(advertising_options.claimed_video_options.channel_override).to be true }
      it { expect(advertising_options.claimed_video_options.new_video_defaults.length).to be 2 }
    end
  end
end
