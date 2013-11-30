require 'test_helper'

class API::TournamentsControllerTest < ActionController::TestCase

  test "should get the latest active tournaments" do
    get :index
    assert_response :success
    assert_equal 1, to_json(response).size
  end

  test "should reject invalid types of tournament" do
    post :create, tournament: {
      :title => 'Invalid',
      :kind  => 'PKR',
      :rules => 'None'
    }
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
    assert to_json(response)['id']
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
    assert to_json(response)['id']
  end

  test "should get the current ranking for a round-robin tournament" do
    get :show, id: 1
    ranking = to_json(response)
    assert_equal 2.0803, ranking[0]['score']
    assert_equal 2.0438, ranking[1]['score']
    assert_equal 1.0175, ranking[2]['score']
    assert_equal 1.0164, ranking[3]['score']
  end

  test "should not allow starting a tournament already started" do
    post :start, :id => '1'
    assert_response :bad_request
  end

  test "should not allow starting a tournament with less than 4 participants" do
    Registration.destroy_all(:tournament_id => 3)
    3.times do |id|
      Registration.new({
        :tournament_id => 3,
        :player_id     => id,
        :accepted      => true
      }).save!
    end
    post :start, :id => '3'
    assert_response :not_implemented
  end

  test "should not allow starting a tournament with more than 20 participants" do
    Registration.destroy_all(:tournament_id => 3)
    21.times do |id|
      Registration.new({
        :tournament_id => 3,
        :player_id     => id,
        :accepted      => true
      }).save!
    end
    post :start, :id => '3'
    assert_response :not_implemented
  end

  test "should start a tournament with the minimum number of participants" do
    post :start, :id => '2'
    assert_response :success
    assert to_json(response)['started']
    assert_equal 6, Match.where(tournament_id: 1).count
  end

  private

  def to_json(response)
    JSON.parse(response.body)
  end

end
