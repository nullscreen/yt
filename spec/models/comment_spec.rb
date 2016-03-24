require 'spec_helper'
require 'yt/models/comment'

describe Yt::Comment do
  subject(:comment) { Yt::Comment.new attrs }

  describe '#snippet' do
    context 'given fetching a comment returns a snippet' do
      let(:attrs) { {snippet: {"videoId" => "12345"}} }
      it { expect(comment.snippet).to be_a Yt::Snippet }
    end
  end

  describe 'attributes' do
    examples = {
      video_id: {with: 'xyz123', without: nil},
      parent_id: {with: 'abc123', without: nil},
      text_display: {with: 'awesome', without: nil},
      author_display_name: {with: 'John', without: nil},
      like_count: {with: 10, without: nil},
      updated_at: {input: '2016-03-22T12:56:56.3Z', with: Time.parse('2016-03-22T12:56:56.3Z'), without: nil},
    }

    examples.each do |attr, cases|
      describe "##{attr}" do
        context "given a snippet with a #{attr}" do
          let(:attrs) {
            {snippet: {"#{attr.to_s.camelize(:lower)}" => cases[:input] || cases[:with]}}}
          it { expect(comment.send(attr)).to eq cases[:with] }
        end

        context "given a snippet without a #{attr}" do
          let(:attrs) { {snippet: {}} }
          it { expect(comment.send(attr)).to eq cases[:without] }
        end
      end
    end
  end
end

