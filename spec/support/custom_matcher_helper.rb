require 'rspec/expectations'

module CustomMatcherHelper
  RSpec::Matchers.define :match_without_concern_for_order do |expected|
    match do |actual|
      actual.all? do |item|
        expected.include? item
      end
    end
  end
end

=begin
#これを書いた理由
  Rspecのmatch_arrayが使えないため書いた。

#使えないとは
  {:'1' => 1}を渡すと[:"1", 1]になってしまう。

  ##したこと
        it {
          binding.pry
  ##出力
    pry(#<RSpec::ExampleGroups::MySet::Initialize::WhenInputIncludeRegexpArrayHash>)>
      expect({:'1' => 1}).to match_array [{:'1' => 1}]

    RSpec::Expectations::ExpectationNotMetError: expected collection contained:  [{:"1"=>1}]
    actual collection contained:    [[:"1", 1]]
    the missing elements were:      [{:"1"=>1}]
    the extra elements were:        [[:"1", 1]]
=end

