require 'test_helper'

class API::MatchesControllerTest < ActionController::TestCase

  def setup
    sign_in players(:random1)
  end

  test "should get an existing match" do
    get :show, id: 1
    assert_response :success
    match = json_response
    assert_equal 1, match['tournament_id']
    assert_equal '1:A', match['pool']
    assert_equal 1, match['player1_id']
    assert_equal 2, match['player2_id']
    assert_equal 1, match['winner_id']
    assert_equal 'DE', match['player1_team']
    assert_equal 'DW', match['player2_team']
    assert_equal 'TKO', match['victory']
    assert_equal 3, match['map']
    assert_equal 50, match['round']
  end

  test "should allow players to update their matches" do
    match_id = 7
    post :update, id: match_id, match: {
      'player1_team' => 'SL',
      'player2_team' => 'DW',
    }
    assert_response :success
    sign_in players(:random4)
    post :update, id: match_id, match: {
      'winner_id' => 4,
      'victory'   => 'CK',
      'map'       => 2,
      'round'     => 45
    }
    assert_response :success
    match = Match.find(match_id)
    assert_equal 1, match.player1.id
    assert_equal 4, match.player2.id
    assert_equal 'SL', match.player1_team
    assert_equal 'DW', match.player2_team
    assert_equal 4, match.winner.id
    assert_equal 'CK', match.victory
    assert_equal 2, match.map
    assert_equal 45, match.round
  end

  test "should allow the host to update any match" do
    match_id = 8
    post :update, id: match_id, match: {
      'player1_team' => 'TR',
      'player2_team' => 'TF',
    }
    assert_response :success
    match = Match.find(match_id)
    assert_equal 'TR', match.player1_team
    assert_equal 'TF', match.player2_team
  end

  test "should not allow a player to update other player's matches" do
    match_id = 9
    post :update, id: match_id, match: {
      'player1_team' => 'CL',
      'player2_team' => 'DE',
    }
    assert_response :unauthorized
  end

  test "should not allow updating a match's players" do
    # TODO
  end

  test "should not allow updating a locked match" do
    # TODO
  end
end
