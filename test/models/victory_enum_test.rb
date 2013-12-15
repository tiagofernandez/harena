require 'test_helper'

class VictoryEnumTest < ActiveSupport::TestCase

  test "should list all types of victory" do
    assert_equal 4, VictoryEnum.all.size
  end

  test "should check if a victory type exists" do
    assert VictoryEnum.has_key?(:TKO)
    assert VictoryEnum.has_key?(:CK)
    refute VictoryEnum.has_key?(:D)
  end

  test "should get code for each type of victory" do
    assert_equal :TKO, VictoryEnum.get_key('Technical Knockout')
    assert_equal :CK, VictoryEnum.get_key('Crystal Kill')
    assert_equal :R, VictoryEnum.get_key('Resignation')
    assert_equal :F, VictoryEnum.get_key('Forfeit')
    assert_raises(ArgumentError) { VictoryEnum.get_key('Death') }
  end

end
