module Googol
  module ClientTokens
    @@client_id =  '461491672627.apps.googleusercontent.com'
    @@client_secret =	'qXRBFZyL9X0NHMEJ_9ItefC3'

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