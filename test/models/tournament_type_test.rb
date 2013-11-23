require 'test_helper'

class TournamentTypeTest < ActiveSupport::TestCase

  test "should list all types of tournament" do
    assert_equal 2, TournamentType.all.size
  end

  test "should get code for each type of tournament" do
    assert_equal :SRR, TournamentType.get_key('Single round-robin')
    assert_equal :DRR, TournamentType.get_key('Double round-robin')
    # assert_equal :SEL, TournamentType.get_key('Single-elimination')
    # assert_equal :DEL, TournamentType.get_key('Double-elimination')
    assert_raises(ArgumentError) { TournamentType.get_key('Poker') }
  end

end
