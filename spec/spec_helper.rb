$:.unshift File.join(File.dirname(__FILE__), '../lib')

require 'chat'

RSpec.configure do |config|
  config.color_enabled = true
  config.add_formatter 'doc'

  def logger
    @logger ||= Logger.new(Chat.root + 'log/test.log')
  end

  Chat.config_logger(logger)
  
  def app
    Chat::Server.new
  end

  def run_server port, server
    pid = fork do
      Chat::Server.start('127.0.0.1', port, server)
    end
    # wait for server to come up
    sleep (0.5)
    yield
  ensure
    Process.kill('KILL', pid) rescue nil
  end
end
