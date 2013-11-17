require 'test_helper'

class TournamentTypeTest < ActiveSupport::TestCase

  test "should list all types of tournament" do
    assert_equal 2, TournamentType.all.size
  end

  test "should get code for each type of victory" do
    assert :RR, TournamentType.get_key('Round-robin')
    assert :KO, TournamentType.get_key('Knockout')
    assert_raises(ArgumentError) { TournamentType.get_key('Poker') }
  end

end