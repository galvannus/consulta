require 'test_helper'
class PermissionsControllerTest < ActionDispatch::IntegrationTest
    def setup
        login
    end
    
    test 'render a list of permissions' do
        get permissions_path

        assert_response :success
        assert_select '.permission', 5
    end

    test 'render a datail of permission page' do
        get permission_path(permissions(:crear_usuario))

        assert_response :success
        #assert_select '.nombre', 'crear_usuario'
        #assert_select '.descripcion', 'Para crear usuarios.'

        #TODO: El test falla por que no se puede testear link_to
        #assert_redirected_to edit_permission_path(permissions(:crear_usuario))
    end

    test 'render a new permission form' do
        get new_permission_path

        assert_response :success
        assert_select 'form'
    end

    test 'allow to create new permission' do
        post permissions_path, params: {
            permission: {
                nombre: 'eliminar_usuario',
                descripcion: 'Para eliminar usuario'
            }
        }

        assert_redirected_to permissions_path
        assert_equal flash[:notice], 'Tu producto se ha creado correctamente'
    end

    test 'does not allow to create new permission with empty fields' do
        post permissions_path, params: {
            permission: {
                nombre: '',
                descripcion: 'Para eliminar usuario'
            }
        }

        assert_response :unprocessable_entity
    end

    test 'render an edit permission form' do
        get edit_permission_path(permissions(:crear_usuario))

        assert_response :success
        assert_select 'form'
    end
    
    test 'allow to update a permission' do
        patch permission_path(permissions(:crear_usuario)), params: {
            permission: {
                descripcion: 'Para eliminar usuario'
            }
        }

        assert_redirected_to permissions_path
        assert_equal flash[:notice], 'Tu producto se ha actualizado correctamente'
    end

    test 'does not allow to update a permission with an invalid field' do
        patch permission_path(permissions(:crear_usuario)), params: {
            permission: {
                descripcion: nil
            }
        }

        assert_response :unprocessable_entity
    end

    test 'can delete permissions' do
        assert_difference('Permission.count', -1) do
            delete permission_path(permissions(:crear_usuario))
        end

        assert_redirected_to permissions_path
        assert_equal flash[:notice], 'Tu producto se ha eliminado correctamente'
    end
end