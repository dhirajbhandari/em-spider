require 'eventmachine'

module Spider
  class Reducer
    attr_reader :expected_count

    def initialize(count)
      @results = []
      @expected_count = count
    end

    def complete(status, result=nil)
      @results << result
      if @results.size == expected_count
        calculate_total
        EM.stop
      end
    end

    def calculate_total
      total = @results.flatten.compact.size
      puts "total image links: #{total}"
    end
  end
end
