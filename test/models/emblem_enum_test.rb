require 'test_helper'

class EmblemEnumTest < ActiveSupport::TestCase

  test "should list all emblems" do
    assert_equal 6, EmblemEnum.all.size
  end

  test "should check if an emblem exists" do
    assert EmblemEnum.has_key?(0)
    assert EmblemEnum.has_key?(5)
    refute EmblemEnum.has_key?(99)
  end

  test "should get code for each emblem" do
    assert_equal 0, EmblemEnum.get_key('Hum-Emblem-hd.png')
    assert_equal 5, EmblemEnum.get_key('SH-Emblem-hd.png')
    assert_raises(ArgumentError) { EmblemEnum.get_key('About_HA_Logo-hd.png') }
  end

end
