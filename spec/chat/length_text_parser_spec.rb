require_relative '../spec_helper'

describe Chat::LengthTextParser do

  let(:parser) { Chat::LengthTextParser.new }
  let(:message) { as_json({"type" => "PING"}) }

  describe '.<<' do
    context 'on recieving valid data' do

      context 'when received in single recieve_data call' do
        it 'should call receive_message with the message' do
          logger.debug("message: \n[#{as_payload(message)}]")
          parser.should_receive(:receive_message!).with(message).once
          parser << as_payload(message) 
        end
      end

      context 'on receiving arbitarily broken data packets' do
        it 'should generate receive_message call only once per full message' do
          parser.should_receive(:receive_message!).with(message).once
          packets = rand_split(as_payload(message))
          packets.each do |pack|
            parser << pack
            sleep 0.2 if rand(2) == 1 # random sleep
          end
        end

        context 'with trailing characters from next message' do 
          it 'should generate receive_message call only once per full message' do
            parser.should_receive(:receive_message!).with(message).once
            packets = rand_split(as_payload(message))
            packets.last << "12\n"
            packets.each do |pack|
              parser << pack
              sleep 0.2 if rand(2) == 1 # random sleep
            end
          end
        end
      end
    end
  end

  def as_payload(message_json)
    "#{message_json.size}\n#{message_json}\n"
  end

  def as_json(message)
    JSON.dump(message)
  end

  def rand_split(str)
    max_size = rand(str.size/3)
    a = []
    i = 0
    while i < str.size
      i2 = rand(max_size)
      i2 = 1 if i2 < 1 # at least 1 char
      a << str[i...i+i2]
      i = i + i2 
    end
    a
  end
end
