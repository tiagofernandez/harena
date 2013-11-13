require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  test "should open the landing page" do
    get :index
    assert_response :success
  end
end
