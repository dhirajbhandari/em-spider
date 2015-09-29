
module Spider

  class HttpClient
    def get(uri)
      require 'net/http'
      Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        request = Net::HTTP::Get.new uri
        response = http.request request # Net::HTTPResponse object
        #logger.debug "response.body: #{response.body}"
        yield response.body
      end
    end

    def logger
      Spider.logger
    end
  end

  class EmHttpClient < HttpClient
    def get(uri)
      http = EventMachine::HttpRequest.new(uri).get

      #on error
      http.errback do
        logger.error 'Uh oh'
        handler.complete(false)
      end

      # on success
      http.callback do
        #p http.response_header.status
        #p http.response_header
        yield http.response
      end
    end
  end
end
