RSpec::Matchers.define :fail do
  supports_block_expectations
  match do |block|
    begin
      block.call
      false
    rescue Yt::Error => error
      @reason ? error.reasons.include?(@reason) : true
    end
  end

  chain :with do |reason|
    @reason = reason
  end
end