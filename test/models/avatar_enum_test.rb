require 'test_helper'

class AvatarEnumTest < ActiveSupport::TestCase

  test "should list all avatars" do
    assert_equal 121, AvatarEnum.all.size
  end

  test "should check if an avatar exists" do
    assert AvatarEnum.has_key?(100)
    assert AvatarEnum.has_key?(215)
    refute AvatarEnum.has_key?(999)
  end

  test "should get code for each avatar" do
    assert_equal 100, AvatarEnum.get_key('Annihilator_v1.jpg')
    assert_equal 215, AvatarEnum.get_key('Wraith_v2.jpg')
    assert_raises(ArgumentError) { AvatarEnum.get_key('About_HA_Logo.png') }
  end

end
