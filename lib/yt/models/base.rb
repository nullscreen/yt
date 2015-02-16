require 'yt/actions/delete'
require 'yt/actions/update'
require 'yt/actions/patch'

require 'yt/associations/has_attribute'
require 'yt/associations/has_authentication'
require 'yt/associations/has_many'
require 'yt/associations/has_one'
require 'yt/associations/has_reports'
require 'yt/associations/has_viewer_percentages'

require 'yt/errors/request_error'

module Yt
  module Models
    class Base
      include Actions::Delete
      include Actions::Update
      include Actions::Patch

      include Associations::HasAttribute
      extend Associations::HasReports
      extend Associations::HasViewerPercentages
      extend Associations::HasOne
      extend Associations::HasMany
      extend Associations::HasAuthentication

      # @private
      # Fetches a remote file in chunks to prevent memory bloat
      def fetch_remote_file(url)
        extension = File.extname(url)
        filename = File.basename(url, extension)

        file = Tempfile.new(["#{filename}-", ".#{extension}"])
        file.binmode # Switch to binary mode

        uri = URI(url)
        Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
          http.request_get(uri.request_uri) do |response|
            response.read_body do |chunk|
              file.write(chunk)
            end
          end
        end

        file.rewind # Read from the beginning
        file
      end
    end
  end

  # By including Models in the main namespace, models can be initialized with
  # the shorter notation Yt::Video.new, rather than Yt::Models::Video.new.
  include Models
end