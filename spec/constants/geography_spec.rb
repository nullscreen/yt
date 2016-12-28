require 'spec_helper'
require 'yt/constants/geography'

describe 'Yt::COUNTRIES' do
  it 'returns all country codes and names' do
    expect(Yt::COUNTRIES[:US]).to eq 'United States'
    expect(Yt::COUNTRIES['IT']).to eq 'Italy'
  end
end

describe 'Yt::US_STATES' do
  it 'returns all U.S. state codes and names' do
    expect(Yt::US_STATES[:CA]).to eq 'California'
    expect(Yt::US_STATES['CO']).to eq 'Colorado'
  end
end
