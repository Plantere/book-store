require "test_helper"

class AuthControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end

  test "should authenticate user and return token" do
    post api_v1_login_path, params: { email: @user.email, password: '12345' }
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_includes json_response, 'token'
  end

  test "should return unauthorized for invalid credentials" do
    post api_v1_login_path, params: { email: @user.email, password: 'wrong_password' }
    assert_response :unauthorized

    json_response = JSON.parse(response.body)
    assert_includes json_response, 'error'
  end
end
