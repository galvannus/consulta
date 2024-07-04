class ServicesController < ApplicationController
  #before_action :set_service, only: %i[ show edit update destroy ]
  before_action :header_menu

  # GET /services or /services.json
  def index
    @services = Service.all
  end

  # GET /services/1 or /services/1.json
  def show
    service
  end

  # GET /services/new
  def new
    @service = Service.new
  end

  # GET /services/1/edit
  def edit
    service
  end

  # POST /services or /services.json
  def create
    @service = Service.new(service_params)
    
    if @service.save
      redirect_to service_url(@service), notice: "Service was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /services/1 or /services/1.json
  def update
      if service.update(service_params)
        redirect_to service_url(@service), notice: "Service was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
  end

  # DELETE /services/1 or /services/1.json
  def destroy
    service.destroy
    
    redirect_to services_url, notice: "Service was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def service
      @service = Service.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def service_params
      params.require(:service).permit(:nombre, :descripcion, :costo, :estado, :category_id, :aumentos)
    end

    def header_menu
			@header_menu = true
		end
end
