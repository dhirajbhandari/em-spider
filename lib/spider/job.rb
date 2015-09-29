require 'eventmachine'
require 'em-http'
require 'nokogiri'
require 'open-uri'

require 'spider/http_client'

module Spider
  class Job

    attr_reader :uri, :handler

    def initialize(uri, on_complete)
      @uri = uri
      @handler = on_complete
    end

    def run
      logger.info "job#run(uri: #{uri})"
      http_client.get(uri) do |response_body|
        on_success(response_body)
      end
    end

    def on_success(response_body)
      img_links = parse(response_body)
      handler.complete(true, img_links)
    end

    def http_client
      HttpClient.new
      #EmHttpClient.new
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
