# encoding: UTF-8
require 'spec_helper'
require 'yt/models/account'

describe Yt::Account, :partner do
  subject(:account) { Yt::Account.new id: id, authentication: $content_owner.authentication }

  describe '.content_owners' do
    let(:content_owners) { account.content_owners }

    context 'given a partenered account with content owners', :partner do
      let(:id) { $content_owner.id }

      specify 'returns the associated content owners' do
        expect(content_owners.size).to be > 0
        expect(content_owners.first).to be_a Yt::ContentOwner
      end

      specify 'includes the display name for each content owner' do
        expect(content_owners.first.display_name).to be_a String
      end

      specify 'ensures the content owners have the same credentials as the account' do
        expect(content_owners.first.access_token).to eq account.access_token
        expect(content_owners.first.refresh_token).to eq account.refresh_token
      end
    end
  end
end