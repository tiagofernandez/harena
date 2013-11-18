require 'test_helper'

class TeamTypeTest < ActiveSupport::TestCase

  test "should list all teams" do
    assert_equal 6, TeamType.all.size
  end

  test "should get code for each team" do
    assert_equal :CL, TeamType.get_key('Council')
    assert_equal :DE, TeamType.get_key('Dark Elves')
    assert_equal :DW, TeamType.get_key('Dwarves')
    assert_equal :TR, TeamType.get_key('Tribe')
    assert_equal :TF, TeamType.get_key('Team Fortress')
    assert_equal :SL, TeamType.get_key('Shaolin')
    assert_raises(ArgumentError) { TeamType.get_key('Zergs') }
  end

end
