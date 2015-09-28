require 'bundler/setup'
require 'pathname'
require 'logger'
require 'spider/client'

Encoding.default_internal = 'UTF-8'
Encoding.default_external = 'UTF-8'


module Spider
  def self.root
    @root ||= Pathname.new(__FILE__).dirname + '..'
  end

  def self.config_logger(logger)
    @logger = logger
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  def self.log_error e
    logger.error e.message
    logger.error e.backtrace.take(20).join($/)
  end

  def self.run(args = nil)
    Spider::Client.new(test_uris).run
  end

  def self.test_uris
    [
      'https://en.wikipedia.org/wiki/Main_Page',
      'http://www.theage.com.au/',
      'http://www.theguardian.com.au/'
    ]
  end
end # Spider

#load all
#Dir.glob(File.join(Pathname.new(__FILE__).dirname + 'spider', '**','*.rb')).sort.each {|rb| require rb}
