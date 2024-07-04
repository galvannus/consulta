class PermissionsController < ApplicationController
    before_action :header_menu

    def index
        @permissions = Permission.all.order(nombre: :desc)
    end

    def show
        permission
    end

    def new
        @permission = Permission.new
    end

    def create
        @permission = Permission.new(permission_params)

        if @permission.save
            redirect_to permissions_path, notice: 'Tu producto se ha creado correctamente'
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        permission
    end

    def update
        if permission.update(permission_params)
            redirect_to permissions_path, notice: 'Tu producto se ha actualizado correctamente'
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        permission.destroy

        redirect_to permissions_path, notice: 'Tu producto se ha eliminado correctamente', status: :see_other
    end

    private

    def permission_params
        params.require(:permission).permit(:nombre, :descripcion)
    end

    def permission
        @permission = Permission.find(params[:id])
    end
    
    def header_menu
        @header_menu = true
    end
end