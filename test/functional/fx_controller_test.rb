require 'test_helper'

class FxControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get upload" do
    get :upload
    assert_response :success
  end

  test "should get destroy" do
    get :destroy
    assert_response :success
  end

end
