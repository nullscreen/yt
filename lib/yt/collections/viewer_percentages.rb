require 'yt/collections/base'

module Yt
  module Collections
    class ViewerPercentages < Base

      def all
        Hash.new{|h,k| h[k] = Hash.new(0.0)}.tap do |hash|
          each{|item| hash[item.gender][item.age_range] = item.value}
        end
      end

    private

      # @note could use column headers to be more precise
      def new_item(data)
        Struct.new(:gender, :age_range, :value).new.tap do |item|
          item.gender = data.first.to_sym
          item.age_range = data.second.gsub /^age/, ''
          item.value = data.last
        end
      end

      def list_params
        super.tap do |params|
          params[:path] = '/youtube/analytics/v1/reports'
          params[:params] = @parent.reports_params.merge reports_params
        end
      end

      def reports_params
        {}.tap do |params|
          params['start-date'] = 3.months.ago.to_date
          params['end-date'] = Date.today.to_date
          params['metrics'] = :viewerPercentage
          params['dimensions'] = 'gender,ageGroup'
          params['sort'] = 'gender,ageGroup'
        end
      end

      def items_key
        'rows'
      end
    end
  end
end