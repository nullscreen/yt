require 'yt/collections/base'
require 'yt/models/channel_section'

module Yt
  module Collections
    # Provides methods for a collection of YouTube channel sections.
    #
    # Resources with channel_sections is {Yt::Models::Channel channels}.
    class ChannelSections < Base

      def attributes_for_new_item(data)
        {}.tap do |attributes|
          attributes[:id] = data['id']
          attributes[:snippet] = data['snippet']
          attributes[:content_details] = data['contentDetails']
        end
      end

      # @return [Hash] the parameters to submit to YouTube to list channel sections.
      # @see https://developers.google.com/youtube/v3/docs/channelSections/list
      def list_params
        super.tap do |params|
          params[:params] = channel_sections_params
          params[:path] = '/youtube/v3/channelSections'
        end
      end

      def channel_sections_params
        {}.tap do |params|
          params[:part] = 'snippet'
          params.merge! @parent.channel_sections_params if @parent
          # TODO: when to mine, when to on_behalf_of_content_owner
          # if @parent.auth
          #   if @parent.auth.owner_name
          #     params[:on_behalf_of_content_owner] = @parent.auth.owner_name
          #   else
          #     params[:mine] = true
          #   end
          # end
          params
        end
      end
    end
  end
end
