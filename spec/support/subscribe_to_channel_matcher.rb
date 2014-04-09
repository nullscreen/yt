RSpec::Matchers.define :be_or_be_already_subscribed do
  match do |actual|
    begin
      actual.call
    rescue Googol::RequestError => e
      e.to_s =~ /subscriptionDuplicate/
    end
  end
end