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
      'kind'  => 'PK',
      'rules' => 'None'
    }
    assert_response :bad_request
  end

  test "should create a round-robin tournament" do
    assert_difference('Tournament.count') do
      post :create, tournament: {
        'title' => 'All-play-all',
        'kind'  => 'RR',
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

  test "should start a tournament with the minimum number of participants" do
    tournament_id = 2
    post :start, id: tournament_id
    assert_response :success
    assert json_response['started']
    created_matches = Match.where(tournament_id: tournament_id)
    assert_equal 8, created_matches.count
    created_matches.each do |m| assert_not_nil m.pool end
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
