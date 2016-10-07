require 'spec_helper'
require 'yt/models/description'

describe Yt::Description do
  subject(:description) { Yt::Description.new text }

  describe '#text' do
    let(:text) { 'this is a description' }
    it { expect(description).to eq 'this is a description' }
  end

  describe '#length' do
    let(:text) { 'twenty one characters' }
    it { expect(description.length).to eq 21 }
  end

  describe '#has_link_to_video?' do
    context 'without a video URL' do
      let(:text) { 'Link to channel: youtube.com/fullscreen' }
      it { expect(description).not_to have_link_to_video }
    end

    context 'with a video long URL' do
      let(:text) { 'example.com and Link to video: youtube.com/watch?v=9bZkp7q19f0' }
      it { expect(description).to have_link_to_video }
    end

    context 'with a video short URL' do
      let(:text) { 'Link to video: youtu.be/9bZkp7q19f0' }
      it { expect(description).to have_link_to_video }
    end

    context 'with a playlist-embedded video URL' do
      let(:text) { 'Link to video in playlist: youtube.com/watch?v=9bZkp7q19f0&index=619&list=LLxO1tY8h1AhOz0T4ENwmpow' }
      it { expect(description).to have_link_to_video }
    end
  end

  describe '#has_link_to_channel?' do
    context 'without a channel URL' do
      let(:text) { 'youtu.be/9bZkp7q19f0 is a video link' }
      it { expect(description).not_to have_link_to_channel }
    end

    context 'with a channel long URL' do
      let(:text) { 'Link to channel: youtube.com/channel/UCxO1tY8h1AhOz0T4ENwmpow' }
      it { expect(description).to have_link_to_channel }
    end

    context 'with a channel short URL' do
      let(:text) { 'Link to channel: youtube.com/fullscreen' }
      it { expect(description).to have_link_to_channel }
    end

    context 'with a channel user URL' do
      let(:text) { 'Link to channel: youtube.com/user/fullscreen' }
      it { expect(description).to have_link_to_channel }
    end
  end

  describe '#has_link_to_subscribe?' do
    context 'without a subscribe URL' do
      let(:text) { 'Link to video: youtu.be/9bZkp7q19f0' }
      it { expect(description).not_to have_link_to_subscribe }
    end

    context 'with a subscribe center URL' do
      let(:text) { 'Link to subscribe: youtube.com/subscription_center?add_user=fullscreen' }
      it { expect(description).to have_link_to_subscribe }
    end

    context 'with a subscribe short URL' do
      let(:text) { 'Link to subscribe: youtube.com/subscribe_widget?p=fullscreen' }
      it { expect(description).to have_link_to_subscribe }
    end

    context 'with a subscribe confirm URL' do
      let(:text) { 'Link to subscribe: youtube.com/channel/UCxO1tY8h1AhOz0T4ENwmpow?sub_confirmation=1' }
      it { expect(description).to have_link_to_subscribe }
    end
  end

  describe '#has_link_to_playlist?' do
    context 'without a playlist URL' do
      let(:text) { 'Link to video: youtu.be/9bZkp7q19f0' }
      it { expect(description).not_to have_link_to_playlist }
    end

    context 'with a playlist long URL' do
      let(:text) { 'Link to playlist: youtube.com/playlist?list=LLxO1tY8h1AhOz0T4ENwmpow' }
      it { expect(description).to have_link_to_playlist }
    end
  end
end