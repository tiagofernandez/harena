require 'test_helper'

class EmblemTypeTest < ActiveSupport::TestCase

  test "should list all emblems" do
    assert_equal 6, EmblemType.all.size
  end

  test "should get code for each emblem" do
    assert_equal 0, EmblemType.get_key('Hum-Emblem-hd.png')
    assert_equal 5, EmblemType.get_key('SH-Emblem-hd.png')
    assert_raises(ArgumentError) { EmblemType.get_key('About_HA_Logo-hd.png') }
  end

end
