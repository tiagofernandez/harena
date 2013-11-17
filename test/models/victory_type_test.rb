require 'test_helper'

class VictoryTypeTest < ActiveSupport::TestCase

  test "should list all types of victory" do
    assert_equal 4, VictoryType.all.size
  end

  test "should get code for each type of victory" do
    assert_equal :TKO, VictoryType.get_key('Technical Knockout')
    assert_equal :CK, VictoryType.get_key('Crystal Kill')
    assert_equal :R, VictoryType.get_key('Resignation')
    assert_equal :F, VictoryType.get_key('Forfeit')
    assert_raises(ArgumentError) { VictoryType.get_key('Death') }
  end

end
