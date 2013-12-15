require 'test_helper'

class MapEnumTest < ActiveSupport::TestCase

  test "should list all maps" do
    assert_equal 7, MapEnum.all.size
  end

  test "should check if a map exists" do
    assert MapEnum.has_key?(0)
    assert MapEnum.has_key?(1)
    refute MapEnum.has_key?(99)
  end

  test "should get code for each map" do
    assert_equal 0, MapEnum.get_key('GameBoard-hd')
    assert_equal 1, MapEnum.get_key('GameBoard02-hd')
    assert_equal 2, MapEnum.get_key('GameBoard03-hd')
    assert_equal 3, MapEnum.get_key('DwarfGameBoard-hd')
    assert_equal 4, MapEnum.get_key('OrcGameBoard-hd')
    assert_equal 5, MapEnum.get_key('GameBoard_TF2-hd')
    assert_equal 6, MapEnum.get_key('GameBoard_Shaolin-hd')
    assert_raises(ArgumentError) { MapEnum.get_key('ProtossGameBoard-hd') }
  end

end
