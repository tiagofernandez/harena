require 'test_helper'

class MapTypeTest < ActiveSupport::TestCase

  test "should list all maps" do
    assert_equal 7, MapType.all.size
  end

  test "should get code for each map" do
    assert 1, MapType.get_key('GameBoard-hd')
    assert 2, MapType.get_key('GameBoard02-hd')
    assert 3, MapType.get_key('GameBoard03-hd')
    assert 4, MapType.get_key('DwarfGameBoard-hd')
    assert 5, MapType.get_key('OrcGameBoard-hd')
    assert 6, MapType.get_key('GameBoard_TF2-hd')
    assert 7, MapType.get_key('GameBoard_Shaolin-hd')
    assert_raises(ArgumentError) { MapType.get_key('ProtossGameBoard-hd') }
  end

end
