require "test_helper"

class Authentication::SessionsControllerTest < ActionDispatch::IntegrationTest

    def setup
        @user = users(:paco)
    end

  test "should get new" do
    get new_session_url
    assert_response :success
  end

  test "should login an user by username" do
    post sessions_url, params: { username: @user.username, password: '123123' }

    assert_redirected_to permissions_url
  end

  test "should logout" do
    login

    delete session_url(@user.id)
    assert_redirected_to permissions_path
    assert_equal flash[:notice], 'Se cerro la sesión correctamente.'
  end
end
