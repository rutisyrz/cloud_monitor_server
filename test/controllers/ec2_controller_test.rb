require 'test_helper'

class Ec2ControllerTest < ActionController::TestCase
  test "should get start" do
    get :start
    assert_response :success
  end

  test "should get stop" do
    get :stop
    assert_response :success
  end

  test "should get instance" do
    get :instance
    assert_response :success
  end

end
