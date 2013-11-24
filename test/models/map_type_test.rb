require 'test_helper'

class MapTypeTest < ActiveSupport::TestCase

  test "should list all maps" do
    assert_equal 7, MapType.all.size
  end

  test "should check if a map exists" do
    assert MapType.has_key?(0)
    assert MapType.has_key?(1)
    refute MapType.has_key?(99)
  end

  test "should get code for each map" do
    assert_equal 0, MapType.get_key('GameBoard-hd')
    assert_equal 1, MapType.get_key('GameBoard02-hd')
    assert_equal 2, MapType.get_key('GameBoard03-hd')
    assert_equal 3, MapType.get_key('DwarfGameBoard-hd')
    assert_equal 4, MapType.get_key('OrcGameBoard-hd')
    assert_equal 5, MapType.get_key('GameBoard_TF2-hd')
    assert_equal 6, MapType.get_key('GameBoard_Shaolin-hd')
    assert_raises(ArgumentError) { MapType.get_key('ProtossGameBoard-hd') }
  end

end
