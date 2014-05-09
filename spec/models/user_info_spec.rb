require 'spec_helper'
require 'yt/models/user_info'
require 'yt/models/account'

describe Yt::UserInfo do
  describe 'given fetching a user info returns' do
    subject(:user_info) { Yt::UserInfo.new data: data }

    context 'an id' do
      let(:data) { {"id"=>"103024385"} }
      it { expect(user_info.id).to eq '103024385' }
    end

    context 'an email' do
      let(:data) { {"email"=>"user@example.com"} }
      it { expect(user_info.email).to eq 'user@example.com' }
    end

    context 'a verified email field set to true' do
      let(:data) { {"verified_email"=>true} }
      it { expect(user_info).to have_verified_email }
    end

    context 'a verified email field set to false' do
      let(:data) { {"verified_email"=>false} }
      it { expect(user_info).not_to have_verified_email }
    end

    context 'a name' do
      let(:data) { {"name"=>"User Example"} }
      it { expect(user_info.name).to eq 'User Example'}
    end

    context 'a given name' do
      let(:data) { {"given_name"=>"User"} }
      it { expect(user_info.given_name).to eq 'User' }
    end

    context 'a family name' do
      let(:data) { {"family_name"=>"Example"} }
      it { expect(user_info.family_name).to eq 'Example' }
    end

    context 'a link' do
      let(:data) { {"link"=>"https://plus.google.com/1234"} }
      it { expect(user_info.profile_url).to eq 'https://plus.google.com/1234' }
    end

    context 'a picture' do
      let(:data) { {"picture"=>"https://lh3.googleusercontent.com/photo.jpg"} }
      it { expect(user_info.avatar_url).to eq 'https://lh3.googleusercontent.com/photo.jpg' }
    end

    context 'a gender' do
      let(:data) { {"gender"=>"male"} }
      it { expect(user_info.gender).to eq 'male' }
    end

    context 'a locale' do
      let(:data) { {"locale"=>"en"} }
      it { expect(user_info.locale).to eq 'en' }
    end

    context 'a Google App domain' do
      let(:data) { {"hd"=>"example.com"} }
      it { expect(user_info.hd).to eq 'example.com' }
    end
  end
end