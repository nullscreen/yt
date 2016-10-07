require 'spec_helper'
require 'yt/models/comment'

describe Yt::Comment, :server_app do
  subject(:comment) { Yt::Comment.new attrs }

  context 'given an existing comment (non-reply) ID' do
    let(:attrs) { {id: 'z13kc1bxpp22hzaxr04cd1kreurbjja41q00k'} }

    it { expect(comment.parent_id).to be_nil }
    it { expect(comment.text_display).to be_a String }
    it { expect(comment.author_display_name).to be_a String }
    it { expect(comment.like_count).to be_a Integer }
    it { expect(comment.updated_at).to be_a Time }
  end

  context 'given an existing comment (reply) ID' do
    let(:attrs) { {id: 'z13kc1bxpp22hzaxr04cd1kreurbjja41q00k.1458679991141996'} }

    it { expect(comment.parent_id).to be_a String }
  end
end
