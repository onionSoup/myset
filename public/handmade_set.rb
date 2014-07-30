class HandmadeSet
require 'timeout'

attr_reader :inner_hash

  def initialize(args)
    inner_hash = {}

    args.each do |arg|
      inner_hash[arg.to_s] = arg
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
          if array.length <= 1
            criteria = array[mid_index]
            next_to_criteria =  get_next_to_criteria(criteria)
            item_to_the_left_of_target = get_right_item_of_target(target, criteria, next_to_criteria)
            insert_position_of_target = @inner_hash.keys.index(item_to_the_left_of_target)
            return {message:'なかった', index: insert_position_of_target}
          end

          array = array.slice!(0.. mid_index-1)
        when 0
          return {message:'あった', index: @inner_hash.keys.index(target)}
        when 1
          if array.length <= 2
            item_to_the_left_of_target= @inner_hash.keys.index(array.last)
            insert_position_of_target = item_to_the_left_of_target + 1
            return {message:'なかった', index: insert_position_of_target}
          end

          array = array.slice!(mid_index+1..array.length)
        else
          raise 'バグった'
        end
      end
    }
  end

  def add_new_item(target)
    binary_search(target.to_s, @inner_hash.keys)
  end

  #a < b      があり
  #x < b      であるとわかっている。
  #知りたいことは
  #x < a < bになるのか、
  #a < x < bになるのか。
                  #x      #a         #b
  def compare_3_of(target, criteria, next_to_criteria)
    case target <=> criteria
    when -1
      return "#{target} < #{criteria} < #{next_to_criteria}" #x < a < b
    when 0
      raise 'target == criteria'
    when 1
      return "#{criteria} < #{target} < #{next_to_criteria}" #a < x < b
    end
  end

  #↑をちょっと変えて、xの右隣になにがくるのかを返す
  def get_right_item_of_target(target, criteria, next_to_criteria)
    case target <=> criteria
    when -1
      return criteria
    when 0
      raise 'target == criteria'
    when 1
      return next_to_criteria
    end
  end

  def get_next_to_criteria(criteria)
    index_of_next_to_criteria = @inner_hash.keys.index(criteria) +1
    @inner_hash.keys[index_of_next_to_criteria]
  end
end
