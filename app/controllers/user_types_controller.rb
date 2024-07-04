class UserTypesController < ApplicationController
  #before_action :set_user_type, only: %i[ edit update destroy ]
  before_action :header_menu

  # GET /user_types or /user_types.json
  def index
    @user_types = UserType.all.order(nombre: :desc)
  end

  # GET /user_types/new
  def new
    @user_type = UserType.new
  end

  # GET /user_types/1/edit
  def edit
    user_type
  end

  # POST /user_types or /user_types.json
  def create
    @user_type = UserType.new(user_type_params)

    if @user_type.save
      redirect_to user_types_url, notice: "User type was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_types/1 or /user_types/1.json
  def update
    if user_type.update(user_type_params)
      redirect_to user_types_url, notice: "User type was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /user_types/1 or /user_types/1.json
  def destroy
    user_type.destroy
    
    redirect_to user_types_url, notice: "User type was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def user_type
      @user_type = UserType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_type_params
      params.require(:user_type).permit(:nombre, :descripcion, permission_ids: [])
    end

    def header_menu
			@header_menu = true
		end
end
