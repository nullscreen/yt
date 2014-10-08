require 'yt/collections/base'

module Yt
  module Collections
    class ViewerPercentages < Base
      delegate :[], to: :all

      def all
        Hash.new{|h,k| h[k] = Hash.new{|h,k| h[k] = Hash.new 0.0}}.tap do |hash|
          each do |item|
            hash[item.id][item.gender][item.age_range] = item.value
          end
        end
      end

    private

      # @note could use column headers to be more precise
      def new_item(data)
        Struct.new(:id, :gender, :age_range, :value).new.tap do |item|
          item.id = data.first
          item.gender = data.second.to_sym
          item.age_range = data.third.gsub /^age/, ''
          item.value = data.last
        end
      end

      def list_params
        super.tap do |params|
          params[:path] = '/youtube/analytics/v1/reports'
          params[:params] = reports_params
          params[:capitalize_params] = false
        end
      end

      def reports_params
        {}.tap do |params|
          params['start-date'] = 3.months.ago.to_date
          params['end-date'] = Date.today.to_date
          params['metrics'] = :viewerPercentage
          params['sort'] = 'gender,ageGroup'
          params.merge! @parent.reports_params if @parent
          apply_where_params! params
          main_dimension = params.fetch(:filters, '').split('==').first
          main_dimension ||= params.fetch(:ids, '').split('==').first
          params['dimensions'] = "#{main_dimension},#{params['sort']}"
        end
      end

      def items_key
        'rows'
      end
    end
  end
end