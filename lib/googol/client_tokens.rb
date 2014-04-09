module Googol
  module ClientTokens
    def client_id
      @@client_id
    end

    def client_secret
      @@client_secret
    end

    def self.client_id=(client_id)
      @@client_id = client_id
    end

    def self.client_secret=(client_secret)
      @@client_secret = client_secret
    end
  end
end