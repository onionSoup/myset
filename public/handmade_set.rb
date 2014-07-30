class HandmadeSet
require 'timeout'

attr_accessor :inner_hash

  def initialize(args)
    inner_hash = {}

    args.each do |arg|
      key = "#{arg.to_s}_#{arg.class}"

      inner_hash[key] = arg
    end
     @inner_hash = inner_hash.sort.to_h
     #まだ'10' < '2'問題と文字コード依存の比較が残っているので注意
     #と思ったけど、これ直感に反していようが、このファイルで一貫したソートができれば
     #二分探索するには十分かもしれない
  end

  def binary_search(target, array)
    timeout(5){
      while(true)
        mid_index = array.length / 2

        case target <=> array[mid_index]
        when -1
          return 'unfound' if array.length <= 1

          array = array.slice!(0.. mid_index-1)
        when 0
          return 'found'
        when 1
          return 'unfound' if array.length <= 2

          array = array.slice!(mid_index+1..array.length)
        else
          raise "bug in #{__method__}"
        end
      end
    }
  end

  def add(target)
    key = "#{target.to_s}_#{target.class}"

    return @inner_hash if binary_search(key, @inner_hash.keys) == 'found' #Hash#has_value?を使わずにやる。

    @inner_hash[key] = target
    @inner_hash = inner_hash.sort.to_h
  end

  alias << add

  def include?(target)
    key = "#{target.to_s}_#{target.class}"
    binary_search(key, @inner_hash.keys) == 'found' ? true : false
  end

  def delete(target)
    key = "#{target.to_s}_#{target.class}"
    h.delete(key)
  end
end
