require 'test_helper'

class API::TournamentsControllerTest < ActionController::TestCase

  test "should require the number of participants when creating a tournament" do
    post :create, tournament: { :kind => 'SRR' }
    assert_response :bad_request
  end

  test "should reject invalid types of tournament" do
    tournament = { :number_of_participants => '10' }
    post :create, tournament: tournament.merge({ :kind => 'ZZZ' })
    assert_response :bad_request
  end

  test "should not allow less than 4 participants in a tournament" do
    post :create, tournament: { :number_of_participants => '3' }
    assert_response :bad_request
  end

  test "should not allow more than 20 participants in a tournament" do
    post :create, tournament: { :number_of_participants => '21' }
    assert_response :bad_request
  end

  test "should create a single round-robin tournament" do
    assert_difference('Tournament.count') do
      post :create, tournament: {
        :title                  => 'All-play-all',
        :kind                   => 'SRR',
        :rules                  => 'Set first-turn AP to 3',
        :number_of_participants => '4'
      }
    end
    assert_response :success
    tournament_id = to_json(response)['id']
    assert_equal 7, Match.where(tournament_id: tournament_id).count
  end

  test "should create a double round-robin tournament" do
    assert_difference('Tournament.count') do
      post :create, tournament: {
        :title                  => 'All-play-all twice',
        :kind                   => 'DRR',
        :rules                  => 'Set first-turn AP to 3',
        :number_of_participants => '4'
      }
    end
    assert_response :success
    tournament_id = to_json(response)['id']
    assert_equal 14, Match.where(tournament_id: tournament_id).count
  end

  private

  def to_json(response)
    JSON.parse(response.body)
  end

end
