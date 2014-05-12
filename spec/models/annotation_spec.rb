require 'spec_helper'
require 'yt/models/annotation'

describe Yt::Annotation do
  subject(:annotation) { Yt::Annotation.new data: Hash.from_xml(xml) }

  describe '#above? and #below?' do
    let(:xml) { %Q{
      <segment>
      <movingRegion type="rect">
      <rectRegion d="0" h="17.7779998779" t="0:04.000" w="25.0" x="7.117000103" y="5.07000017166"/>
      <rectRegion d="0" h="17.7779998779" t="0:05.000" w="25.0" x="7.117000103" y="5.07000017166"/>
      </movingRegion>
      </segment>
    } }

    context 'given an annotation located above N% of the video height' do
      it { expect(annotation.above? 50).to be_true }
      it { expect(annotation.below? 50).to be_false }
    end

    context 'given an annotation located below N% of the video height' do
      it { expect(annotation.above? 5).to be_false }
      it { expect(annotation.below? 5).to be_true }
    end

    context 'given an annotation without explicit location' do
      let(:xml) { '<segment></segment>' }
      it { expect(annotation.above? 50).to be_false }
      it { expect(annotation.below? 50).to be_false }
    end
  end

  describe '#has_link_to_subscribe?' do
    context 'given an annotation with a link of class 5' do
      let(:xml) { '<action type="openUrl"><url link_class="5"/></action>' }
      it { expect(annotation).to have_link_to_subscribe }
    end

    context 'given an annotation without a link of class 5' do
      let(:xml) { '<action type="openUrl"><url link_class="3"/></action>' }
      it { expect(annotation).not_to have_link_to_subscribe }
    end
  end

  describe '#has_link_to_video?' do
    context 'given an annotation with a link of class 1' do
      let(:xml) { '<action type="openUrl"><url link_class="1"/></action>' }
      it { expect(annotation).to have_link_to_video }
    end

    context 'given an annotation with a "featured video" invideo programming' do
      let(:xml) { '<type>promotion</type>' }
      it { expect(annotation).to have_link_to_video }
    end

    context 'given an annotation without a link of class 1' do
      let(:xml) { '<action type="openUrl"><url link_class="3"/></action>' }
      it { expect(annotation).not_to have_link_to_video }
    end
  end

  describe '#has_link_to_playlist?' do
    context 'given an annotation with a link of class 2' do
      let(:xml) { '<action type="openUrl"><url link_class="2"/></action>' }
      it { expect(annotation).to have_link_to_playlist }
    end

    context 'given an annotation with an embedded playlist link' do
      let(:xml) { '<TEXT>https://www.youtube.com/watch?v=MESycYJytkU&amp;list=LLxO1tY8h1AhOz0T4ENwmpow"</TEXT>' }
      it { expect(annotation).to have_link_to_playlist }
    end

    context 'given an annotation without a link of class 2' do
      let(:xml) { '<action type="openUrl"><url link_class="3"/></action>' }
      it { expect(annotation).not_to have_link_to_playlist }
    end
  end

  describe '#has_link_to_same_window?' do
    context 'given an annotation with a "current" target' do
      let(:xml) { '<action type="openUrl"><url target="current"/></action>' }
      it { expect(annotation).to have_link_to_same_window }
    end

    context 'given an annotation without a "current" target' do
      let(:xml) { '<action type="openUrl"><url target="new"/></action>' }
      it { expect(annotation).not_to have_link_to_same_window }
    end
  end

  describe '#has_invideo_programming?' do
    context 'given an annotation with a "featured video" invideo programming' do
      let(:xml) { '<type>promotion</type>' }
      it { expect(annotation).to have_invideo_programming }
    end

    context 'given an annotation with a "branding intro" invideo programming' do
      let(:xml) { '<type>branding</type>' }
      it { expect(annotation).to have_invideo_programming }
    end

    context 'given an annotation without an invideo programming' do
      let(:xml) { '<segment></segment>' }
      it { expect(annotation).not_to have_invideo_programming }
    end
  end

  describe '#starts_after and #starts_before' do
    context 'given an annotation with the first timestamp equal to 1 hour' do
      let(:xml) { %Q{
        <segment>
        <movingRegion type="rect">
        <rectRegion d="0" h="17.7779998779" t="01:00:01.000" w="25.0" x="7.117000103" y="5.07000017166"/>
        <rectRegion d="0" h="17.7779998779" t="01:05:56.066" w="25.0" x="7.117000103" y="5.07000017166"/>
        </movingRegion>
        </segment>
      } }
      it { expect(annotation.starts_after? 3600).to be_true }
      it { expect(annotation.starts_after? 3610).to be_false }
      it { expect(annotation.starts_before? 3600).to be_false }
      it { expect(annotation.starts_before? 3610).to be_true }
    end

    context 'given an annotation without timestamps' do
      let(:xml) { '<segment></segment>' }
      it { expect(annotation.starts_after? 0).to be_nil }
      it { expect(annotation.starts_before? 0).to be_nil }
    end
  end
end