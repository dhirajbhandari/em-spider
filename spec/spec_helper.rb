$:.unshift File.join(File.dirname(__FILE__), '../lib')

require 'spider'

RSpec.configure do |config|
  config.color_enabled = true
  config.add_formatter 'doc'

  def logger
    @logger ||= Logger.new(spider.root + 'log/test.log')
  end

  spider.config_logger(logger)
end
