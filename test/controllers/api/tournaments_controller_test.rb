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

  test "should get the registered players of an unstarted tournament" do
    get :show, id: 7
    registered = json_response['registered']
    assert_equal 6, registered.select { |r| r['accepted'] }.size
  end

  test "should get the current ranking for a round-robin tournament" do
    get :show, id: 1
    ranking = json_response['ranking']
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
    post :start, :id => -1
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

  test "should require both tournament and player for creating a registration" do
    refute Registration.new.valid?
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
      game = m.game
      assert game.include?(':')
      round = game[0...game.index(':')]
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
    new_tournament.save! :validate => false
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

  test "should not allow registering to unexisting tournaments" do
    post :register, id: -1
    assert_response :not_found
  end

  test "should not allow registering to started tournaments" do
    post :register, id: 4
    assert_response :bad_request
  end

  test "should not allow registering twice to the same tournament" do
    post :register, id: 2
    assert_response :conflict
  end

  test "should register to a tournament that hasn't already started" do
    post :register, id: 6
    assert_response :success
  end

  test "should not accept a registration of an unexisting tournament" do
    post :accept, id: -1
    assert_response :not_found
  end

  test "should not accept players once the tournament has already started" do
    post :accept, id: 4
    assert_response :bad_request
  end

  test "should not accept unregistered players" do
    post :accept, id: 8
    assert_response :conflict
  end

  test "should accept or reject registered players" do
    tournament_id, player_id = 7, 7
    post :accept, id: tournament_id, player_id: player_id, accepted: true
    assert_response :success
    registration = Registration.where(tournament_id: tournament_id, player_id: player_id).first
    assert registration.accepted
    post :accept, id: tournament_id, player_id: player_id, accepted: false
    assert_response :success
    registration = Registration.where(tournament_id: tournament_id, player_id: player_id).first
    refute registration.accepted
  end
end
