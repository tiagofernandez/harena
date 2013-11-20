require 'test_helper'

class MatchTest < ActiveSupport::TestCase

  test "should create and update a match" do
    player1 = players(:random1)
    player2 = players(:random2)
    match = Match.new({
      :player1      => player1,
      :player2      => player2,
      :player1_team => 'CL',
      :player2_team => 'DE',
    })
    assert match.save!
    assert match.id
    assert_equal 1, Match.all.size

    match.winner  = player2
    match.victory = 'TKO'
    match.map     = 1
    assert match.save!

    updated_match = Match.find_by_id(match.id)
    assert_equal player1.id,         updated_match.player1.id
    assert_equal player2.id,         updated_match.player2.id
    assert_equal match.player1_team, updated_match.player1_team
    assert_equal match.player2_team, updated_match.player2_team
    assert_equal match.victory,      updated_match.victory
    assert_equal match.map,          updated_match.map
  end

end
