require 'test_helper'

class TeamTypeTest < ActiveSupport::TestCase

  test "should list all teams" do
    assert_equal 6, TeamType.all.size
  end

  test "should get code for each team" do
    assert :CL, TeamType.get_key('Council')
    assert :DE, TeamType.get_key('Dark Elves')
    assert :DW, TeamType.get_key('Dwarves')
    assert :TR, TeamType.get_key('Tribe')
    assert :TF, TeamType.get_key('Team Fortress')
    assert :SL, TeamType.get_key('Shaolin')
    assert_raises(ArgumentError) { TeamType.get_key('Zergs') }
  end

end
