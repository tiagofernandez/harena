require 'test_helper'

class AvatarTypeTest < ActiveSupport::TestCase

  test "should list all avatars" do
    assert_equal 117, AvatarType.all.size
  end

  test "should get code for each avatar" do
    assert_equal 100, AvatarType.get_key('Annihilator_v1-hd.jpg')
    assert_equal 215, AvatarType.get_key('Wraith_v2-hd.jpg')
    assert_raises(ArgumentError) { AvatarType.get_key('About_HA_Logo-hd.png') }
  end

end
