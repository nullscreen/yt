require 'spec_helper'
require 'yt/models/content_owner'

describe Yt::ContentOwner, :partner do
  # NOTE: Uncomment once size does not runs through *all* the pages
  # it { expect($content_owner.partnered_channels.size).to be > 0 }
  it { expect($content_owner.partnered_channels.first).to be_a Yt::Channel }
end