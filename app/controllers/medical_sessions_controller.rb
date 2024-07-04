class MedicalSessionsController < ApplicationController
	before_action :header_menu
	before_action :verify_current_medical_session, only: [:create]
	
	def new
		@medical_session = MedicalSession.new
		@medics = User.where("user_type_id = ?", 2).order(apellido_paterno: :asc)
	end

	def create
		if params[:user_id].present?
			user_ids = [params[:user_id], Current.user.id]
			
			@medical_session = MedicalSession.new
			@medical_session.user_ids = user_ids
			#session[:user_id] = @user.id

			if @medical_session.save
				session[:medical_session_id] = @medical_session.id
				redirect_to sucursal_path, notice: "Session was successfully created."
			else
				render :new, status: :unprocessable_entity
			end

		else
			render :new, status: :unprocessable_entity
		end
	end

	private

		# Only allow a list of trusted parameters through.
		def medical_session_params
			params.require(:medical_session).permit(:totalVendido, :totalServicios, :conteoConsultas, :conteoAplicaciones, :conteoServicios, :estado, :user_id)
		end

		def header_menu
			@header_menu = true
		end

		def verify_current_medical_session
			current_date = DateTime.now
        	current_date = current_date.strftime("%Y/%m/%d")
			
			medical_session = MedicalSession.joins(:user_medical_sessions).where("DATE(created_at) = ? 
                AND estado = ? AND user_medical_sessions.user_id = ? ",
                current_date,0,Current.user.id).limit(1)

            if !medical_session.blank?
				session.delete(:user_id)
				redirect_to new_session_path, alert: 'No se pudo iniciar sesión'
            end
        end
        
end