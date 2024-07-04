require "test_helper"

class UserTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login
    @user_type = user_types(:administrador)
  end

  test "should get index" do
    get user_types_url
    assert_response :success
  end

  test "should get new" do
    get new_user_type_url
    assert_response :success
  end

  test "should create user_type" do
    assert_difference("UserType.count") do
      post user_types_url, params: {
        user_type: {
          descripcion: @user_type.descripcion,
          nombre: @user_type.nombre,
          permission_id: permissions(:crear_usuario).id
        }
      }
    end

    assert_redirected_to user_types_url
  end

  test "should get edit" do
    get edit_user_type_url(@user_type)
    assert_response :success
  end

  test "should update user_type" do
    patch user_type_url(@user_type), params: {
      user_type: {
        descripcion: @user_type.descripcion,
        nombre: @user_type.nombre
      }
    }
    assert_redirected_to user_types_url
  end

  test "should destroy user_type" do
    assert_difference("UserType.count", -1) do
      delete user_type_url(@user_type)
    end

    assert_redirected_to user_types_url
  end
end
