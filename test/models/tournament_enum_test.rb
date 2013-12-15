require 'test_helper'

class TournamentEnumTest < ActiveSupport::TestCase

  test "should list all types of tournament" do
    assert_equal 1, TournamentEnum.all.size
  end

  test "should check if a tournament type exists" do
    assert TournamentEnum.has_key?(:SRR)
    refute TournamentEnum.has_key?(:SKO)
    refute TournamentEnum.has_key?(:PKR)
  end

  test "should get code for each type of tournament" do
    assert_equal :SRR, TournamentEnum.get_key('Round-robin')
    assert_raises(ArgumentError) { TournamentEnum.get_key('Knockout') }
    assert_raises(ArgumentError) { TournamentEnum.get_key('Poker') }
  end

end
