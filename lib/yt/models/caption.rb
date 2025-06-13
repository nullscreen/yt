require 'yt/models/resource'
require "fileutils"

module Yt
  module Models
    # Provides methods to interact with YouTube video captions.
    # @see https://developers.google.com/youtube/v3/docs/captions
    class Caption < Resource

      # @return [String] the ID used to identify the caption.
      has_attribute :id

      delegate :video_id, to: :snippet
      delegate :last_updated, to: :snippet
      delegate :language, to: :snippet
      delegate :name, to: :snippet
      delegate :status, to: :snippet

      # Downloads a caption file.
      # @param [String] path A name for the downloaded file with caption content.
      # @see https://developers.google.com/youtube/v3/docs/captions#resource
      def download(path)
        case io
        when StringIO then File.open(path, 'w') { |f| f.write(io.read) }
        when Tempfile then io.close; FileUtils.mv(io.path, path)
        end
      end

      def io
        @io ||= get_request(download_params).open_uri
      end

    private

      # @return [Hash] the parameters to submit to YouTube to download caption.
      # @see https://developers.google.com/youtube/v3/docs/captions/download
      def download_params
        {}.tap do |params|
          params[:method] = :get
          params[:host] = 'youtube.googleapis.com'
          params[:auth] = @auth
          params[:exptected_response] = Net::HTTPOK
          params[:api_key] = Yt.configuration.api_key if Yt.configuration.api_key
          params[:path] = "/youtube/v3/captions/#{@id}"
          if @auth.owner_name
            params[:params] = {on_behalf_of_content_owner: @auth.owner_name}
          end
        end
      end
    end
  end
end
