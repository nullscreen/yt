require 'spec_helper'
require 'yt/models/policy_rule'

describe Yt::PolicyRule do
  subject(:policy_rule) { Yt::PolicyRule.new data: data }

  describe '#action' do
    context 'given fetching a policy rule returns an action' do
      let(:data) { {"action"=>"takedown"} }
      it { expect(policy_rule.action).to eq 'takedown' }
    end
  end

  describe '#subaction' do
    context 'given fetching a policy rule returns a subaction' do
      let(:data) { {"subaction"=>"review"} }
      it { expect(policy_rule.subaction).to eq 'review' }
    end
  end

  describe '#included_territories' do
    context 'given fetching a policy rule returns included territories' do
      let(:data) { {"conditions"=>{"requiredTerritories"=>{"type"=>"include", "territories"=>["US", "CA"]}}} }
      let(:data) { {"conditions"=>{"requiredTerritories"=>{"type"=>"include", "territories"=>["US", "CA"]}}} }
      it { expect(policy_rule.included_territories).to eq %w(US CA) }
    end
  end

  describe '#excluded_territories' do
    context 'given fetching a policy rule returns excluded territories' do
      let(:data) { {"conditions"=>{"requiredTerritories"=>{"type"=>"exclude", "territories"=>["US", "CA"]}}} }
      it { expect(policy_rule.excluded_territories).to eq %w(US CA) }
    end
  end

  describe '#match_duration' do
    context 'given fetching a policy rule returns a match duration list' do
      let(:data) { {"conditions"=>{"matchDuration"=>[{"high"=>60.0}]}} }
      it { expect(policy_rule.match_duration).to match_array [{low: nil, high: 60.0}] }
    end
  end

  describe '#match_percent' do
    context 'given fetching a policy rule returns a match percent list' do
      let(:data) { {"conditions"=>{"matchPercent"=>[{"high"=>60.0}]}} }
      it { expect(policy_rule.match_percent).to match_array [{low: nil, high: 60.0}] }
    end
  end

  describe '#reference_duration' do
    context 'given fetching a policy rule returns a reference duration list' do
      let(:data) { {"conditions"=>{"referenceDuration"=>[{"low"=>60.0, "high"=>600.0}, {"low"=>20.0, "high"=>30.0}]}} }
      it { expect(policy_rule.reference_duration).to match_array [{low: 60.0, high: 600.0}, {low: 20.0, high: 30.0}] }
    end
  end

  describe '#reference_percent' do
    context 'given fetching a policy rule returns a reference percent list' do
      let(:data) { {"conditions"=>{"referencePercent"=>[{"low"=>60.0, "high"=>600.0}, {"low"=>20.0, "high"=>30.0}]}} }
      it { expect(policy_rule.reference_percent).to match_array [{low: 60.0, high: 600.0}, {low: 20.0, high: 30.0}] }
    end
  end
end