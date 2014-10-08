# encoding: UTF-8
require 'spec_helper'
require 'yt/collections/viewer_percentages'

describe Yt::Collections::ViewerPercentages, :partner do
  subject(:viewer_percentages) { Yt::Collections::ViewerPercentages.new auth: $content_owner }

  context 'for two channels at once' do
    let(:filters) { 'channel==UCxO1tY8h1AhOz0T4ENwmpow,UCsmvakQZlvGsyjyOhmhvOsw' }
    let(:ids) { "contentOwner==#{$content_owner.owner_name}" }
    let(:result) { viewer_percentages.where filters: filters, ids: ids }

    it 'returns the viewer percentages of both' do
      expect(result['UCggO99g88eUDPcqkTShOPvw'][:female]['18-24']).to be_a Float
      expect(result['UC8oJ8Sdgkpcy4gylGjTHtBw'][:male]['18-24']).to be_a Float
    end
  end
end