require 'test_helper'

class TournamentTypeTest < ActiveSupport::TestCase

  test "should list all types of tournament" do
    assert_equal 1, TournamentType.all.size
  end

  test "should check if a tournament type exists" do
    assert TournamentType.has_key?(:SRR)
    refute TournamentType.has_key?(:SKO)
    refute TournamentType.has_key?(:PKR)
  end

  test "should get code for each type of tournament" do
    assert_equal :SRR, TournamentType.get_key('Round-robin')
    assert_raises(ArgumentError) { TournamentType.get_key('Knockout') }
    assert_raises(ArgumentError) { TournamentType.get_key('Poker') }
  end

end
