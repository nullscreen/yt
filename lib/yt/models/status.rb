module Yt
  class Status
    def initialize(options = {})
      @data = options[:data]
    end

    # @return [Boolean] Is the resource public?
    def public?
      privacy_status == 'public'
    end

    # @return [Boolean] Is the resource private?
    def private?
      privacy_status == 'private'
    end

    # @return [Boolean] Is the resource unlisted?
    def unlisted?
      privacy_status == 'unlisted'
    end

    def privacy_status
      @privacy_status ||= @data['privacyStatus']
    end
  end
end