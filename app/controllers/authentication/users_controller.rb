class Authentication::UsersController < ApplicationController
    #skip_before_action :protect_pages
    before_action :header_menu, only: [:new]
    
    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)

        if @user.save
            session[:user_id] = @user.id
            redirect_to permissions_path, notice: 'Usuario Creado.'
        else
            render :new, status: :unprocessable_entity
        end
    end

    private

    def user_params
        params.require(:user).permit(:nombre, :apellido_paterno, :apellido_materno, :email, :username, :password, :user_type_id)
    end

    def header_menu
        @header_menu = true
    end
end