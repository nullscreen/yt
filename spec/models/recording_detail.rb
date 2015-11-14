require 'spec_helper'
require 'yt/models/snippet'

describe Yt::RecordingDetail do
  subject(:recording_detail) { Yt::RecordingDetail.new data: data }

  let(:data) do
    {
      "locationDescription" => "Deep blue forest",
      "location" => {
        "latitude" => 48.44,
        "longitude" => 137.30,
        "altitude" => 949.00
      },
      "recordingDate" => "2012-03-17T00:00:00.000Z"
    }
  end

  describe '#data' do
    specify 'returns the data the recording_data was initialized with' do
      expect(recording_detail.data).to eq data
    end
  end

  describe '#location_description' do
    context 'given fetching recording details returns a location description' do
      it { expect(recording_detail.location_description).to eq 'Deep blue forest' }
    end
  end

  describe '#location' do
    context 'given fetching recording details returns a location' do
      it { expect(recording_detail.location).to eq data['location'] }
    end
  end

  describe '#recording_date' do
    context 'given fetching recording details returns a recording date' do
      it { expect(recording_detail.recording_date).to eq Time.parse(data['recordingDate']) }
    end
  end
end
