require "test_helper"

class Authentication::UsersControllerTest < ActionDispatch::IntegrationTest

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      post users_url, params: {
        user: {
          email: 'ejemplo@ejemplo.com',
          username: 'ejemplo21',
          password: '123123',
          user_type_id: user_types(:medico).id
        }
      }
    end

    assert_redirected_to permissions_url
  end
end
