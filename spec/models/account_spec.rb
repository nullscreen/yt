require 'spec_helper'
require 'yt/models/account'

describe Yt::Video do
  subject(:account) { Yt::Account.new attrs }

  describe '#id' do
    context 'given a user info with an ID' do
      let(:attrs) { {user_info: {"id"=>"103024385"}} }
      it { expect(account.id).to eq '103024385' }
    end

    context 'given a user info without an ID' do
      let(:attrs) { {user_info: {}} }
      it { expect(account.id).to eq '' }
    end
  end

  describe '#email' do
    context 'given a user info with an email' do
      let(:attrs) { {user_info: {"email"=>"user@example.com"}} }
      it { expect(account.email).to eq 'user@example.com' }
    end

    context 'given a user info without an email' do
      let(:attrs) { {user_info: {}} }
      it { expect(account.email).to eq '' }
    end
  end

  describe '#has_verified_email?' do
    context 'given a user info with a verified email' do
      let(:attrs) { {user_info: {"verified_email"=>true}} }
      it { expect(account).to have_verified_email }
    end

    context 'given a user info without a verified email' do
      let(:attrs) { {user_info: {"verified_email"=>false}} }
      it { expect(account).not_to have_verified_email }
    end
  end

  describe '#name' do
    context 'given a user info with a name' do
      let(:attrs) { {user_info: {"name"=>"User Example"}} }
      it { expect(account.name).to eq 'User Example' }
    end

    context 'given a user info without a name' do
      let(:attrs) { {user_info: {}} }
      it { expect(account.name).to eq '' }
    end
  end

  describe '#given_name' do
    context 'given a user info with a given name' do
      let(:attrs) { {user_info: {"given_name"=>"User"}} }
      it { expect(account.given_name).to eq 'User' }
    end

    context 'given a user info without a given name' do
      let(:attrs) { {user_info: {}} }
      it { expect(account.given_name).to eq '' }
    end
  end

  describe '#family_name' do
    context 'given a user info with a family name' do
      let(:attrs) { {user_info: {"family_name"=>"Example"}} }
      it { expect(account.family_name).to eq 'Example' }
    end

    context 'given a user info without a family name' do
      let(:attrs) { {user_info: {}} }
      it { expect(account.family_name).to eq '' }
    end
  end

  describe '#profile_url' do
    context 'given a user info with a link' do
      let(:attrs) { {user_info: {"link"=>"https://plus.google.com/1234"}} }
      it { expect(account.profile_url).to eq 'https://plus.google.com/1234' }
    end

    context 'given a user info without a link' do
      let(:attrs) { {user_info: {}} }
      it { expect(account.profile_url).to eq '' }
    end
  end

  describe '#avatar_url' do
    context 'given a user info with a picture' do
      let(:attrs) { {user_info: {"picture"=>"https://lh3.googleusercontent.com/photo.jpg"}} }
      it { expect(account.avatar_url).to eq 'https://lh3.googleusercontent.com/photo.jpg' }
    end

    context 'given a user info without a picture' do
      let(:attrs) { {user_info: {}} }
      it { expect(account.avatar_url).to eq '' }
    end
  end

  describe '#gender' do
    context 'given a user info with a gender' do
      let(:attrs) { {user_info: {"gender"=>"male"}} }
      it { expect(account.gender).to eq 'male' }
    end

    context 'given a user info without a gender' do
      let(:attrs) { {user_info: {}} }
      it { expect(account.gender).to eq '' }
    end
  end

  describe '#locale' do
    context 'given a user info with a locale' do
      let(:attrs) { {user_info: {"locale"=>"en"}} }
      it { expect(account.locale).to eq 'en' }
    end

    context 'given a user info without a locale' do
      let(:attrs) { {user_info: {}} }
      it { expect(account.locale).to eq '' }
    end
  end

  describe '#hd' do
    context 'given a user info with a Google App domain' do
      let(:attrs) { {user_info: {"hd"=>"example.com"}} }
      it { expect(account.hd).to eq 'example.com' }
    end

    context 'given a user info without a Google App domain' do
      let(:attrs) { {user_info: {}} }
      it { expect(account.hd).to eq '' }
    end
  end
end
