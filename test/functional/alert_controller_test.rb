require 'test_helper'

class AlertControllerTest < ActionController::TestCase
  test "should get setting" do
    get :setting
    assert_response :success
  end

end
