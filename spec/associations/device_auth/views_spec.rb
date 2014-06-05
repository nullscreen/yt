require 'spec_helper'

describe Yt::Associations::Views, :partner do
  context 'given a partnered channel' do
    let(:channel) { Yt::Channel.new id: channel_id, auth: $content_owner }

    context 'managed by the authenticated Content Owner' do
      let(:channel_id) { ENV['YT_TEST_PARTNER_CHANNEL_ID'] }

      describe '#views_on' do
        context 'and a date in which the channel was partnered' do
          let(:views) { channel.views_on 5.days.ago}
          it { expect(views).to be_an Integer }
        end

        context 'and a date in which the channel was not partnered' do
          let(:views) { channel.views_on 20.years.ago}
          it { expect(views).to be_nil }
        end
      end

      describe '#views' do
        let(:date) { 4.days.ago }

        context 'given a :since option' do
          let(:views) { channel.views since: date}
          it { expect(views.keys.min).to eq date.to_date }
        end

        context 'given a :from option' do
          let(:views) { channel.views from: date}
          it { expect(views.keys.min).to eq date.to_date }
        end

        context 'given a :until option' do
          let(:views) { channel.views until: date}
          it { expect(views.keys.max).to eq date.to_date }
        end

        context 'given a :to option' do
          let(:views) { channel.views to: date}
          it { expect(views.keys.max).to eq date.to_date }
        end
      end
    end

    context 'not managed by the authenticated Content Owner' do
      let(:channel_id) { 'UCBR8-60-B28hp2BmDPdntcQ' }
      it { expect{channel.views}.to raise_error Yt::Errors::Forbidden }
    end
  end
end