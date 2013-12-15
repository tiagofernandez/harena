require 'test_helper'

class TeamEnumTest < ActiveSupport::TestCase

  test "should list all teams" do
    assert_equal 6, TeamEnum.all.size
  end

  test "should check if a team exists" do
    assert TeamEnum.has_key?(:CL)
    assert TeamEnum.has_key?(:DE)
    refute TeamEnum.has_key?(:ZZ)
  end

  test "should get code for each team" do
    assert_equal :CL, TeamEnum.get_key('Council')
    assert_equal :DE, TeamEnum.get_key('Dark Elves')
    assert_equal :DW, TeamEnum.get_key('Dwarves')
    assert_equal :TR, TeamEnum.get_key('Tribe')
    assert_equal :TF, TeamEnum.get_key('Team Fortress')
    assert_equal :SL, TeamEnum.get_key('Shaolin')
    assert_raises(ArgumentError) { TeamEnum.get_key('Zergs') }
  end

end
