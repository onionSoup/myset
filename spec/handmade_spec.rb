require 'rspec/rails'
require "#{Rails.root.to_s << '/public/handmade_set'}"

def build_in_set(input)
  Set.new(input).to_a
end

def handmade_set(input)
  HandmadeSet.new(input).inner_hash.values
end

describe 'MySet' do
  describe 'initialize' do
    context 'when input are class_name and string_of_class_name' do
      input = [Array, 'Array']
      it { expect(handmade_set(input)).to match build_in_set(input) }
    end

    context 'when input include regexp, array, range, hash' do
      input = [/1/, [1], :'1', (1..1), {:'1' => 1}, 1, '1']
      #rspecのmatchが{:'1' => 1}でバグを出すため自作マッチャを使う。
      it { expect(handmade_set(input)).to match_without_concern_for_order build_in_set(input) }
    end

    context 'when input include minus, decimal, binary, octal, hex' do
      input = [-1, 1.0, 0b1, 0o1, 0x1, 1]
      it { expect(handmade_set(input)).to match build_in_set(input) }
    end
  end
end
