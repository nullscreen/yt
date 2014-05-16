require 'yt/models/base'

module Yt
  class Subscription < Base

    attr_reader :id

    def initialize(options = {})
      @id = options[:id]
      @auth = options[:auth]
    end

    def delete(options = {})
      begin
        do_delete {@id = nil}
      rescue Errors::Base => error
        ignorable_errors = error.reasons & ['subscriptionNotFound']
        raise error unless options[:ignore_errors] && ignorable_errors.any?
      end
      !exists?
    end

    def exists?
      !@id.nil?
    end

  private

    def delete_params
      super.tap do |params|
        params[:path] = '/youtube/v3/subscriptions'
        params[:params] = {id: @id}
      end
    end
  end
end