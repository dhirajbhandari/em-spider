
require_relative '../spec_helper'

describe Chat::CircularBuffer do

  let(:items) do
    (1..5).map {|i| "item_#{i}".to_sym }
  end

  let(:capacity) { 6 } 

  let(:buffer) { Chat::CircularBuffer.new(capacity) }

  describe "<<" do
    it 'should store the item' do
      buffer << :itemx
      buffer.to_a.should == [:itemx]
    end

    context 'when more than 1 items are added upto capacity' do
      before { items.each {|i| buffer << i } }
      it 'should store the items' do
        buffer.to_a.should == items
      end
    end

    context 'when more items that capacity is added' do
      let (:capacity) { 4 }
      before { items.each {|i| buffer << i } }

      it 'should discard older items that are over the capacity' do
        buffer.to_a.should_not include(items.first)
      end
    end
  end

  describe ".each" do
    context 'when under capacity' do
      before { items.each {|i| buffer << i } }

      it 'should return items in FIFO order' do
        buffer.each_with_index do |item, i |
          item.should == items[i]
        end
      end
    end
    context 'when items are added more than capacity' do
      let(:capacity) { 4 }

      before { items.each {|i| buffer << i } }

      it 'the count should be equal to capacity' do
        buffer.count.should == capacity
      end

      it 'should discard older items, maintaining the FIFO order of remaining items' do
        expected_items = items[1,5]
        #buffer.to_a.sort.should == expected_items.sort
        buffer.each.with_index do |item, i |
          item.should == expected_items[i]
        end
      end
    end
  end
end
