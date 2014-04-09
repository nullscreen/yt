module Googol
  module ServerTokens
    def server_key
      @@server_key
    end

    def self.server_key=(server_key)
      @@server_key = server_key
    end
  end
end