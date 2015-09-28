require 'eventmachine'
require 'em-http'
require 'nokogiri'
require 'open-uri'

module Spider
  class Job

    attr_reader :uri, :handler

    def initialize(uri, on_complete)
      @uri = uri
      @handler = on_complete
    end

    def run
      logger.info "job#run(uri: #{uri})"
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
        res = http.response
        img_links = parse(res)
        handler.complete(true, img_links)
      end
    end

    def parse(response)
      doc = Nokogiri::HTML.parse(response)
      img_links = doc.xpath('//img')
      logger.info "image link.count: #{img_links.count}"
      img_links
    end

    def logger
      Spider.logger
    end
  end
end
