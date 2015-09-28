
require 'eventmachine'
require 'json'

module Chat
  module Spec
    class TestClient < EM::Connection

      attr_accessor :buffer

      def initialize
        @buffer = ''
      end

      #include EM::Protocols::LineText2
      def post_init
        @buffer = ''
        ping
      end

      def receive_data(data)
        puts "data: #{data} buffer: [#{@buffer}]"
        @buffer += data if data and data.length > 0
        puts "2..data: #{data} buffer: [#{@buffer}]"
        @buffer.each_char.with_index do |char, idx|
          if char == "\n"
            line = @buffer[0...idx]
            @buffer = @buffer[idx+1...@buffer.size] || ''
            line_received(line)
          end
        end
      end

      def line_received(line)
        EM.defer do 
          puts "[Server]-> #{line}\n"
        end
        #console
      end

      def ping
        send_msg "command" => 'PING'
      end

      def send_msg json
        msg = JSON.dump(json)
        send_data "#{msg.length}\n#{msg}\n"
      end

      def unbind
        puts "unbinding Client"
      end

      def console
        EM.next_tick do
          send_msg 'command' => 'SEND', 'from' => 'TestClient', 'Text' => 'Hi there'
        end
      end
    end
  end
end

    EM.run {
      EM.connect '127.0.0.1', 9090, Chat::Spec::TestClient do |conn|
        conn.buffer = ''
      end

      EM.add_timer(120) { EM.stop }
    }



