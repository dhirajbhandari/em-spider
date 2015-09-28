require 'eventmachine'
require 'spider/job'
require 'spider/reducer'

module Spider
  class Client
    attr_reader :uris

    def initialize(uris)
      @uris = uris
    end

    def run
      reducer = Reducer.new(uris.size)  
      jobs = uris.map do |uri|
        Job.new(URI(uri), reducer)
      end

      EventMachine::run do
        logger.info "-- EventMachine Reactor started ---"
        jobs.each(&:run)
        #EventMachine.stop
      end

      logger.info "-- EventMachine Reactor stopped ---"
    end

    def blocking_get(uri)
     require 'net/http'
      Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        request = Net::HTTP::Get.new uri
        response = http.request request # Net::HTTPResponse object
        logger.info "response.body: #{response.body}"
        response
      end
    end

    def logger
      Spider.logger
    end
  end
end
