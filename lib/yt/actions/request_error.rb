module Yt
  class RequestError < StandardError
    def reasons
      error.fetch('errors', []).map{|e| e['reason']}
    end

    def error
      eval(message)['error'] rescue {}
    end
  end
end