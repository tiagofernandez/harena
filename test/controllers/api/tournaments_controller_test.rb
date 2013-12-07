require 'test_helper'

class API::TournamentsControllerTest < ActionController::TestCase

  def setup
    sign_in players(:random1)
  end

  test "should get the latest active tournaments" do
    get :index
    assert_response :success
    assert_equal 2, json_response.size
  end

  test "should reject invalid types of tournament" do
    post :create, tournament: {
      'title' => 'Invalid',
      'kind'  => 'PKR',
      'rules' => 'None'
    }
    assert_response :bad_request
  end

  test "should create a round-robin tournament" do
    assert_difference('Tournament.count') do
      post :create, tournament: {
        'title' => 'All-play-all',
        'kind'  => 'SRR',
        'rules' => 'Set first-turn AP to 3'
      }
    end
    assert_response :success
    tournament_id = json_response['id']
    assert tournament_id
    assert_equal 1, Tournament.find(tournament_id).host.id
  end

  test "should get the current ranking for a round-robin tournament" do
    get :show, id: 1
    ranking = json_response
    assert_equal 2.0803, ranking[0]['score']
    assert_equal 2.0438, ranking[1]['score']
    assert_equal 1.0175, ranking[2]['score']
    assert_equal 1.0164, ranking[3]['score']
  end

  test "should not allow starting a tournament already started" do
    post :start, :id => 1
    assert_response :bad_request
  end

  test "should not allow starting another player's tournament" do
    post :start, :id => 6
    assert_response :unauthorized
  end

  test "should not allow starting an unexisting tournament" do
    post :start, :id => 99
    assert_response :not_found
  end

  test "should not allow starting a tournament with less than 4 participants" do
    tournament_id = 3
    Registration.destroy_all(:tournament_id => tournament_id)
    3.times do |id|
      Registration.new({
        :tournament_id => tournament_id,
        :player_id     => id,
        :accepted      => true
      }).save!
    end
    post :start, :id => tournament_id
    assert_response :not_implemented
  end

  test "should not allow starting a tournament with more than 20 participants" do
    tournament_id = 3
    Registration.destroy_all(:tournament_id => tournament_id)
    21.times do |id|
      Registration.new({
        :tournament_id => tournament_id,
        :player_id     => id,
        :accepted      => true
      }).save!
    end
    post :start, id: 3
    assert_response :not_implemented
  end

  test "should not allow starting a tournament with an even number of participants" do
    tournament_id = 3
    Registration.destroy_all(:tournament_id => tournament_id)
    9.times do |id|
      Registration.new({
        :tournament_id => tournament_id,
        :player_id     => id,
        :accepted      => true
      }).save!
    end
    post :start, id: 3
    assert_response :not_implemented
  end

  test "should start a tournament with the minimum number of participants" do
    tournament_id = 7
    post :start, id: tournament_id
    assert_response :success
    assert json_response['started']
    created_matches = Match.where(tournament_id: tournament_id)
    assert_equal 15, created_matches.count
    scheduled = {}
    created_matches.each do |m|
      pool = m.pool
      assert pool.include?(':')
      round = pool[0...pool.index(':')]
      scheduled[round] = [] if !scheduled.include?(round)
      refute scheduled[round].include?(m.player1.id)
      refute scheduled[round].include?(m.player2.id)
      scheduled[round] << m.player1.id << m.player2.id
    end
    played = created_matches.map { |m| [m.player1.id, m.player2.id] }.flatten
    1.upto(6) { |player_id| assert_equal 5, played.count(player_id) }
  end

  test "should allow updating a tournament" do
    tournament_id = 1
    post :update, id: tournament_id, tournament: {
      'rules' => 'Set first-turn AP to 3'
    }
    assert_response :success
    assert_not_equal 'None', Tournament.find(tournament_id).rules
  end

  test "should not allow updating another player's tournament" do
    tournament_id = 6
    post :update, id: tournament_id, tournament: {
      'rules' => 'Set first-turn AP to 3'
    }
    assert_response :unauthorized
    assert_equal 'None', Tournament.find(tournament_id).rules
  end

  test "should allow deleting a tournament that hasn't started yet" do
    new_tournament = Tournament.new({ :host_id => 1 })
    new_tournament.save!
    post :destroy, id: new_tournament.id
    assert_response :success
    assert_equal 0, Tournament.where(id: new_tournament.id).count
  end

  test "should not allow deleting a tournament that has already started" do
    tournament_id = 1
    post :destroy, id: tournament_id
    assert_response :unauthorized
    assert Tournament.find(tournament_id)
  end

  test "should not allow deleting another player's tournament" do
    tournament_id = 4
    post :destroy, id: tournament_id
    assert_response :unauthorized
    assert Tournament.find(tournament_id)
  end
end
