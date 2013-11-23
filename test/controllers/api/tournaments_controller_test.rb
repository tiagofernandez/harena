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
        :title                  => 'Death Arena',
        :kind                   => 'SRR',
        :rules                  => 'Last one standing wins.',
        :number_of_participants => '10'
      }
    end
  end

end
