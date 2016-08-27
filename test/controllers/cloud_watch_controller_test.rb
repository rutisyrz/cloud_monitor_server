require 'test_helper'

class CloudWatchControllerTest < ActionController::TestCase
  test "should get metrics" do
    get :metrics
    assert_response :success
  end

  test "should get statistics" do
    get :statistics
    assert_response :success
  end

end
