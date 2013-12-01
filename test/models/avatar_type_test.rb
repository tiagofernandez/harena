require 'test_helper'

class AvatarTypeTest < ActiveSupport::TestCase

  test "should list all avatars" do
    assert_equal 117, AvatarType.all.size
  end

  test "should check if an avatar exists" do
    assert AvatarType.has_key?(100)
    assert AvatarType.has_key?(215)
    refute AvatarType.has_key?(999)
  end

  test "should get code for each avatar" do
    assert_equal 100, AvatarType.get_key('Annihilator_v1.jpg')
    assert_equal 215, AvatarType.get_key('Wraith_v2.jpg')
    assert_raises(ArgumentError) { AvatarType.get_key('About_HA_Logo.png') }
  end

end
