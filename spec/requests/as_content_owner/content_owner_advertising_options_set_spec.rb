require 'spec_helper'
require 'yt/models/content_owner_advertising_options_set'
require 'yt/models/claimed_video_defaults_set'
require 'yt/models/allowed_advertising_options_set'

describe Yt::ContentOwnerAdvertisingOptionsSet, :partner do
  let(:advertising_options) { $content_owner.content_owner_advertising_options_set }
end
