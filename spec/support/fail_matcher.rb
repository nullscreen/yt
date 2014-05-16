RSpec::Matchers.define :fail do
  match do |block|
    begin
      block.call
      false
    rescue Yt::Errors::Base => error
      with_reason = @reason ? error.reasons.include?(@reason) : true
      with_reason && error.message =~ /failed/
    end
  end

  chain :with do |reason|
    @reason = reason
  end
end