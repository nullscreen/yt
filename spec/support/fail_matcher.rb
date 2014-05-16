RSpec::Matchers.define :fail do
  match do |block|
    begin
      block.call
      false
    rescue Yt::Errors::Base => error
      @reason ? error.reasons.include?(@reason) : true
    end
  end

  chain :with do |reason|
    @reason = reason
  end
end