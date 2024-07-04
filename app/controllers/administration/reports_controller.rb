class Administration::ReportsController < ApplicationController
    before_action :header_menu
    
    def index
        #date = DateTime.now
        #date = date.strftime("%Y-%m-%d %H:%M:%S")
        @min_date = min_current_date
        @max_date = today

        @sucursal = User.where(user_type_id: 1).order(nombre: :asc)
        @medics = User.where("user_type_id = ?", 2).order(apellido_paterno: :asc)

        if params[:commit] == "Buscar"
            initial_date = "#{params[:start_at]} 00:00"
            final_date = "#{params[:finish_at]} 23:59:59"
            
            if params[:report_type] == "medic" && 
                current_month.cover?(Date.parse(initial_date)) && current_month.cover?(Date.parse(final_date))

                if params[:reporte] == "detallado"
                    if params[:sucursal_id] == ""
                        @medical_session = MedicalSession.includes(:user_medical_sessions, :appointments)
                            .where("medical_sessions.created_at BETWEEN ? AND ? AND user_medical_sessions.user_id = ?",
                            initial_date,final_date,params[:user_id]).references(:appointments)
                    else
                        #TODO: Refactor query for use a User.where
                        query_sessions = []
                        sessions = []
                        #User.where(id: params[:sucursal_id]).includes(:medical_sessions).where("
                        #total_consultas > 0 AND medical_sessions.created_at BETWEEN ? AND ?",
                        #initial_date,final_date).references(:medical_sessions)
    
                        MedicalSession.includes(:user_medical_sessions)
                        .where("medical_sessions.created_at BETWEEN ? AND ? AND (user_medical_sessions.user_id = ?
                        OR user_medical_sessions.user_id = ?)",
                        initial_date,final_date,params[:sucursal_id], Current.user.id).references(:user_medical_sessions)
                        .each { |session| sessions << session.user_medical_sessions.find { |e| e.user_id  == Current.user.id } }
                        
                        sessions.compact!
                        sessions.each { |a| query_sessions << a.medical_session_id }

                        @medical_session = MedicalSession.where(id: query_sessions).includes(:appointments).references(:appointments)
                    end
                end

                if params[:reporte] == "agrupado"
                    if params[:sucursal_id] != ""
                        @users = User.where(id: params[:sucursal_id]).includes(:medical_sessions).where(" 
                        total_consultas > 0 AND medical_sessions.created_at BETWEEN ? AND ?",
                        initial_date,final_date).references(:medical_sessions)
                    else
                        @users = User.where(id: Current.user.id).includes(:medical_sessions).where("
                        medical_sessions.total_consultas > 0 AND medical_sessions.created_at BETWEEN ? AND ?",
                        initial_date,final_date).references(:medical_sessions)
                    end
                end
            elsif params[:report_type] == "sucursal" && 
                current_month.cover?(Date.parse(initial_date)) && current_month.cover?(Date.parse(final_date))

                if params[:reporte] == "detallado"
                    if params[:medic_id] == ""
                        @medical_session = MedicalSession.includes(:user_medical_sessions, :appointments)
                            .where("medical_sessions.created_at BETWEEN ? AND ? AND user_medical_sessions.user_id = ?",
                            initial_date,final_date,params[:sucursal_id]).references(:appointments)
                    else
                        query_sessions = []
                        sessions = []

                        MedicalSession.includes(:user_medical_sessions)
                        .where("medical_sessions.created_at BETWEEN ? AND ? AND (user_medical_sessions.user_id = ?
                        OR user_medical_sessions.user_id = ?)",
                        initial_date,final_date,params[:medic_id], Current.user.id).references(:user_medical_sessions)
                        .each { |session| sessions << session.user_medical_sessions.find { |e| e.user_id  == Current.user.id } }
                        
                        sessions.compact!
                        sessions.each { |a| query_sessions << a.medical_session_id }

                        @medical_session = MedicalSession.where(id: query_sessions).includes(:appointments).references(:appointments)
                    end
                end

                if params[:reporte] == "agrupado"
                    if params[:medic_id] != ""
                        @users = User.where(id: params[:medic_id]).includes(:medical_sessions).where(" 
                        total_consultas > 0 AND medical_sessions.created_at BETWEEN ? AND ?",
                        initial_date,final_date).references(:medical_sessions)
                    else
                        @users = User.where(id: Current.user.id).includes(:medical_sessions).where("
                        medical_sessions.total_consultas > 0 AND medical_sessions.created_at BETWEEN ? AND ?",
                        initial_date,final_date).references(:medical_sessions)
                    end
                end
            elsif params[:report_type] == "admin"

                if params[:reporte] == "detallado"
                    if params[:medic_id] == ""
                        @medical_session = MedicalSession.includes(:user_medical_sessions, :appointments)
                        .where("medical_sessions.created_at BETWEEN ? AND ? AND user_medical_sessions.user_id = ?",
                        initial_date,final_date,params[:sucursal_id]).references(:appointments)
                    elsif params[:sucursal_id] == ""
                        @medical_session = MedicalSession.includes(:user_medical_sessions, :appointments)
                        .where("medical_sessions.created_at BETWEEN ? AND ? AND user_medical_sessions.user_id = ?",
                        initial_date,final_date, params[:medic_id]).references(:appointments)
                    else
                        @medical_session = MedicalSession.includes(:user_medical_sessions, :appointments)
                        .where("medical_sessions.created_at BETWEEN ? AND ? AND user_medical_sessions.user_id = ? 
                        AND appointments.user_id = ?",
                        initial_date,final_date,params[:sucursal_id], params[:medic_id]).references(:appointments)
                    end

                elsif params[:reporte] == "agrupado"
                    if params[:sucursal_id].present? || params[:medic_id].present?
                        user_selected = params[:sucursal_id] != "" ? params[:sucursal_id] : params[:medic_id]

                        @users = User.where(id: user_selected).includes(:medical_sessions).where("
                        total_consultas > 0 AND medical_sessions.created_at BETWEEN ? AND ?",
                        initial_date,final_date).references(:medical_sessions)
                    else
                        @users = User.where("users.user_type_id = 2").includes(:medical_sessions).where("
                        medical_sessions.total_consultas > 0 AND medical_sessions.created_at BETWEEN ? AND ?",
                        initial_date,final_date)
                        .references(:medical_sessions)
                    end

                elsif params[:reporte] == "dias"
                    user_to_search = ""

                    if (params[:sucursal_id].present? && !params[:medic_id].present?) || 
                        (params[:medic_id].present? && !params[:sucursal_id].present?)
                        
                        user_to_search = User.where(id: user_selected).includes(:medical_sessions).where("
                        total_consultas > 0 AND medical_sessions.created_at BETWEEN ? AND ?",
                        initial_date,final_date).references(:medical_sessions)

                    elsif params[:sucursal_id].present? && params[:medic_id].present?
                        user_to_search = User.where(id: user_selected).includes(:medical_sessions).where("
                        total_consultas > 0 AND medical_sessions.created_at BETWEEN ? AND ?",
                        initial_date,final_date).references(:medical_sessions)
                    else
                        user_to_search = User.includes(:medical_sessions).where("
                        total_consultas > 0 AND medical_sessions.created_at BETWEEN ? AND ?",
                        initial_date,final_date).references(:medical_sessions)
                    end
                end
            end
        end
    end

    def modal_report_detail
        @service_list = ServiceAcquired.where(appointment_id: params[:appointment_id])
        @appointment = Appointment.find_by(id: params[:appointment_id])
    end

    private

    def report_params
        params.require(:report).permit()
    end

    def header_menu
        @header_menu = true
    end

    def current_month
        today.beginning_of_month..today.end_of_month
    end

    def min_current_date
        today.beginning_of_month
    end

    def max_current_date
        today.end_of_month
    end

    def today
        Date.current
    end
end