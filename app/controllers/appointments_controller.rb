class AppointmentsController < ApplicationController
    before_action :header_menu, except: [:print_ticket]
    before_action :verify_current_medical_session
    
    def panel_medico
        @session_consulta = session[:medical_session_id]

        @appointments_createds = Appointment.where("medical_session_id = ? AND estado <> 3 AND estado <> 4",@session_consulta)
        @appointments_canceleds = Appointment.where("medical_session_id = ? AND estado = 4",@session_consulta)
        @appointment = Appointment.find_by(id: params[:appointment_selected])
        @servicesList = ServiceAcquired.where(appointment: @appointment)#TODO: Refactor
        
        if params[:commit].present?
            service_appointment_created = 0
            service_injection_created = 0
            @consulta_creada = false
            @aplicacion_creada = false
            @cortesia_activa = @appointment.cortesia == 1 ? true : false
    
            @servicesList.each do |service|
                if service.service_id == 2
                    service_appointment_created = service
                    @consulta_creada = true
                elsif service.service_id == 3
                    service_injection_created = service
                    @aplicacion_creada = true
                end
            end

            current_appointment = @appointment

            #Manage when the user modify the current appointment
            if params[:commit] == 'Iniciar' || params[:commit] == 'Modificar'
                
                if params[:commit] == 'Iniciar'
                    date = current_date
                    
                    current_appointment.update(estado: 1, started_by_doctor_at: date)
                    current_appointment.broadcast_appointment_modified
                else
                    current_appointment.update(estado: 1)
                    current_appointment.broadcast_appointment_modified
                end
                
                redirect_to medico_path(appointment_selected: current_appointment.id, commit: 1)
                
            elsif params[:commit] == 'Finalizar'

                #Check if a new service was selected
                if params[:consulta] == "1"
                    if !@consulta_creada
                        service_consulta = Service.find_by(id: 2)

                        new_service = ServiceAcquired.new
                        new_service.appointment_id = current_appointment.id
                        new_service.service_id = 2
                        new_service.costo = service_consulta.costo
                        new_service.cantidad = 1
                        new_service.save
                    end
                elsif @consulta_creada
                    service_appointment_created.destroy
                end

                if params[:aplicacion] == "1"
                    if !@aplicacion_creada
                        service_consulta = Service.find_by(id: 3)

                        new_service = ServiceAcquired.new
                        new_service.appointment_id = current_appointment.id
                        new_service.service_id = 3
                        new_service.costo = service_consulta.costo
                        new_service.cantidad = 1
                        new_service.save
                    end
                elsif @aplicacion_creada
                    service_injection_created.destroy
                end

                #Se cambian los costos de los servicios a 0
                if params[:cortesia] == "1"
                    if !@cortesia_activa
                        current_appointment.update(cortesia: 1)
                        services_list = ServiceAcquired.where(appointment: current_appointment)#TODO: Refactor
                        services_list.update_all(costo: 0)
                    end

                #Se cambian los costos de los servicios al costo actual
                elsif @cortesia_activa
                    services_list = ServiceAcquired.where(appointment: current_appointment)#TODO: Refactor
                    current_appointment.update(cortesia: 0)

                    services_list.each do |service|
                        service.update(costo: service.service.costo)
                    end
                end

                services_list = ServiceAcquired.where(appointment: current_appointment)#TODO: Refactor

                if services_list.blank?
                    redirect_to medico_path(appointment_selected: current_appointment.id, commit: 1)
                else
                    date = current_date
                    total_servicios = 0
                    observacion = params[:observacion].strip
    
                    services_list.each do |service|
                        total_servicios += service.costo
                    end

                    if current_appointment.update(estado: 2, finished_by_doctor_at: date, observacion: observacion, total_servicios: total_servicios)
                        current_appointment.broadcast_appointment_modified
                        redirect_to medico_path(appointment_selected: current_appointment.id, commit: 2)
                    end
                end
            end
        end

        if params[:service_acquired_id].present?
            service = ServiceAcquired.find_by(id: params[:service_acquired_id])

            if params[:accion] == "plus"
                plusOne = service.cantidad+1

                if plusOne < 3
                    if service.update(cantidad: plusOne)
                        service.broadcast_service_modified
                    end
                end
            elsif params[:accion] == "minus"
                minusOne = service.cantidad-1

                if minusOne < 1
                    service.destroy
                    #TODO: Fix error: Uncaught (in promise) Error: The response (200) did not contain the expected <turbo-frame id="service_acquired_137"> and will be ignored. To perform a full page visit instead, set turbo-visit-control to reload.
                    service.broadcast_remove_service
                else
                    if service.update(cantidad: minusOne)
                        service.broadcast_service_modified
                    end
                end
            elsif params[:accion] == "delete"
                service.destroy
                #TODO: Fix error: Uncaught (in promise) Error: The response (200) did not contain the expected <turbo-frame id="service_acquired_137"> and will be ignored. To perform a full page visit instead, set turbo-visit-control to reload.
                service.broadcast_remove_service
            end
        end
    end

    def panel_sucursal
        @session_consulta = session[:medical_session_id]

        @appointment = Appointment.new
        @appointments_createds = Appointment.where(
            "medical_session_id = ? AND estado <> 4 AND estado <> 3",
            session[:medical_session_id]
        )

        @can_finish_session = false
        if @appointments_createds.blank?
            @can_finish_session = true
        end
        
        @current_medic = ""
        user_sessions = UserMedicalSession.where(medical_session_id: @session_consulta)
        user_sessions.each do |session|
            if session.user.user_type.nombre == "medico"
                @current_medic = session.user
            end
        end

        if params[:commit] == "Finalizar"
            total_servicios = params[:total_servicios]
            venta_generada = params[:venta_generada]
            atendido_por = params[:atendido_por].strip
            receta = params[:receta]
            date = current_date
            promedio = 0
            promediar = false
            consulta = false

            current_appointment = Appointment.find_by(id: params[:appointment_id])
            @service_list = ServiceAcquired.where(appointment: current_appointment).where("service_id <> ? AND  service_id <> ?",2,3)

            #Check if the appointment count to the average
            services = ServiceAcquired.where(appointment: current_appointment)
            services.each do |service|
                if service.service_id == 2
                    consulta = true
                elsif service.service_id == 4
                    promedio += 1
                elsif service.service_id == 5
                    promedio += 1
                elsif service.service_id == 6
                    promedio += 1
                else
                    promediar = true
                end
            end

            if consulta && (promedio == 0 || promediar)
                promedio = 1
            else
                promedio = 0
            end

            #Update appointment
            if current_appointment.update(
                    estado: 3, finished_at: date, atendido_por: atendido_por,
                    total_servicios: total_servicios, total_vendido: venta_generada,
                    receta: receta, promedio: promedio
                )
                current_appointment.broadcast_remove_appointment

                appointments_createds = Appointment.where(
                    "medical_session_id = ? AND estado <> 4 AND estado <> 3",
                    session[:medical_session_id]
                )
                
                if appointments_createds.blank?
                    current_appointment.broadcast_btn_finish
                end
            end
            redirect_to sucursal_path

        elsif params[:commit] == "Cancelar"
            can_cancel = false
            
            if params[:verify_auth] == "Password"
                medic_user = params[:medic_user].strip
                password = params[:password].strip

                user = User.find_by("username = :username", { username: medic_user })

                if user&.user_type.nombre == "medico"
                    if user&.authenticate(password)
                        can_cancel = true
                    end
                end
            else
                can_cancel = true
            end

            if can_cancel
                appointment = Appointment.find_by(id: params[:appointment_id])
                observacion = params[:observacion].strip

                appointment.update(estado: 4, observacion: observacion)
                appointment.broadcast_canceled_appointment
            end

            redirect_to sucursal_path
        end
    end

    def modal_services
        @session_consulta = session[:medical_session_id]
        
        if params[:service_id].present?
            service = Service.find_by(id: params[:service_id])
            service_acquired = ServiceAcquired.where(appointment_id: params[:appointment_id], service_id: service.id)

            if service_acquired.blank?
                newService = ServiceAcquired.new
                newService.appointment_id = params[:appointment_id]
                newService.service_id = service.id
                newService.costo = service.costo
                
                if newService.save!
                    newService.broadcast_service
                else
                    render :modal_services, status: :unprocessable_entity
                end
            end
        end
        
        #TODO: Add validation to ignore services: INyeccion im, cortesia, consulta
        if params[:servicio].present?
            @servicesList = Service.where("nombre LIKE ? ", "%"+params[:servicio]+"%")
        else
            @servicesList = Service.all
        end
    end

    def index
        @appointments = Appointment.all
    end

    def show
    end

    def new
        @appointments = Appointment.new
    end

    def create
        date = DateTime.now
        date = date.strftime("%Y/%m/%d")
        current_medic = ""

        service_ids = []

        if params[:appointment][:consulta] == "1"
            service_ids << 2
        end
        if params[:appointment][:aplicacion] == "1"
            service_ids << 3
        end

        lastAppointments = Appointment.where("medical_session_id = ? AND DATE(created_at) = ?",
        session[:medical_session_id],date).order('id DESC').limit(1)

        user_sessions = UserMedicalSession.where(medical_session_id: session[:medical_session_id])
        
        user_sessions.each do |session|
            if session.user.user_type.nombre == "medico"
                current_medic = session.user_id
            end
        end

        services_acquired = []

        if !service_ids.empty?
            query_services = ""
            iteration = 0

            for service in service_ids do
                iteration+=1
                if iteration > 1
                    query_services += " OR id = #{service}"
                else
                    query_services += "id = #{service}"
                end
            end
            services = Service.where(query_services)

            for service in services do
                services_acquired << {service_id: service.id, costo: service.costo}
            end
        end
        
        @appointment = Appointment.new

        if lastAppointments.empty?
            @appointment.nombre_paciente = params[:appointment][:nombre_paciente]
            @appointment.clave = "A"
            @appointment.consecutivo = "1"
            @appointment.medical_session_id = session[:medical_session_id]
            @appointment.user_id = current_medic
            @appointment.service_acquireds.build(services_acquired)
            #@appointment.service_ids = service_ids
        else
            clave = lastAppointments[0].clave
            consecutivo = Integer(lastAppointments[0].consecutivo,  exception: false)

            if consecutivo >= 10
                clave_ascii = clave.ord + 1
                clave = clave_ascii.chr
                consecutivo = 1
            else
                consecutivo += 1
            end
            
            @appointment.nombre_paciente = params[:appointment][:nombre_paciente]
            @appointment.clave = clave
            @appointment.consecutivo = consecutivo
            @appointment.medical_session_id = session[:medical_session_id]
            @appointment.user_id = current_medic
            @appointment.service_acquireds.build(services_acquired)
        end
        
        if @appointment.save
            @appointment.broadcast
            redirect_to print_ticket_path(clave: @appointment.clave, consecutivo: @appointment.consecutivo)
            #redirect_to sucursal_path, notice: "Session was successfully created."
        else
            render :new, status: :unprocessable_entity
        end
    end

    def print_ticket
        if params[:commit].present?
            total_servicios = params[:total_servicios]
            venta_generada = params[:venta_generada]
            atendido_por = params[:atendido_por]
            receta = params[:receta]
            date = current_date
            promedio = 0
            promediar = false
            consulta = false

            appointment = Appointment.find_by(id: params[:appointment_id])

            if params[:commit] == "Finalizar"
                @service_list = ServiceAcquired.where(appointment: appointment).where("service_id <> ? AND  service_id <> ?",2,3)

                #Check if the appointment count to the average
                services = ServiceAcquired.where(appointment: appointment)
                services.each do |service|
                    if service.service_id == 2
                        consulta = true
                    elsif service.service_id == 4
                        promedio += 1
                    elsif service.service_id == 5
                        promedio += 1
                    elsif service.service_id == 6
                        promedio += 1
                    else
                        promediar = true
                    end
                end

                if consulta && (promedio == 0 || promediar)
                    promedio = 1
                else
                    promedio = 0
                end

                #Update appointment
                if appointment.update(
                        estado: 3, finished_at: date, atendido_por: atendido_por,
                        total_servicios: total_servicios, total_vendido: venta_generada,
                        receta: receta, promedio: promedio
                    )
                    appointment.broadcast_remove_appointment
                    
                    appointments_createds = Appointment.where( "medical_session_id = ? AND estado <> 4 AND estado <> 3",
                        session[:medical_session_id]
                    )

                    if appointments_createds.blank?
                        appointment.broadcast_btn_finish
                    end
                end

            elsif params[:commit] == "Cancelar"
                appointment.update(estado: 4, observacion: params[:observacion])
                appointment.broadcast_remove_appointment
            end
        elsif params[:session_consulta].present?
            session_appointments = Appointment.where("medical_session_id = ? AND estado = 3",
                params[:session_consulta]
            )
            total_consultas = 0
            total_otros_servicios = 0
            total_vendido = 0
            conteo_consultas = 0
            conteo_inyection = 0
            conteo_otros_servicios = 0
            @conteo_consultas_ticket = 0
            @total_consultas_ticket = 0
            @total_otros_servicios_ticket = 0

            #Get totals of the medical session
            session_appointments.each do |appointment|
                services_acquired = appointment.service_acquireds

                services_acquired.each do |service|
                    #Sum totals
                    if service.service_id == 2
                        total_consultas += service.costo
                    else
                        total_otros_servicios += service.cantidad * service.costo
                    end

                    #Counting totals
                    if service.service_id == 3
                        conteo_inyection += 1
                    elsif service.service_id == 2
                        conteo_consultas += 1
                    else
                        conteo_otros_servicios += 1
                    end

                    #Counting totals for ticket
                    if appointment.cortesia != 1
                        if service.service_id == 2
                            @conteo_consultas_ticket += 1
                            @total_consultas_ticket += service.costo
                        else
                            @total_otros_servicios_ticket += service.cantidad * service.costo
                        end
                    end
                end
                
                total_vendido += appointment.total_vendido
            end

            @medical_session = MedicalSession.find_by(id: params[:session_consulta])
            @appointment_cost = Service.select("costo").find_by(id: 2)

            if @medical_session.update(total_vendido: total_vendido, 
                total_consultas: total_consultas, total_otros_servicios: total_otros_servicios, estado: 1,
                conteo_consultas: conteo_consultas, conteo_aplicaciones: conteo_inyection,
                conteo_otros_servicios: conteo_otros_servicios)
                session.delete(:user_id)
            end
        end
    end

    def modal_finish_appointment
        appointment = Appointment.find_by(id: params[:appointment_id])
        @servicesList = ServiceAcquired.where(appointment: appointment)#TODO: Refactor
    end

    def modal_cancel_appointment
    end

    def edit
    end

    def update
    end

    def destroy
    end

    private
        def appointment_params
            params.require(:appointment).permit(:nombre_paciente, :clave, :consecutivo, :total_consultas, :total_vendido, :total_otros_servicios, :estado, :finished_at, :user_id, :consulta, :aplicacion)
        end

        def header_menu
            @header_menu = true
        end

        def current_date
            date = DateTime.now
            date = date.strftime("%Y-%m-%d %H:%M:%S")
        end

        def verify_current_medical_session
            medical_session = MedicalSession.select("estado").find_by(id: session[:medical_session_id])

            if !medical_session.blank?
                if medical_session.estado != 0
                    session.delete(:user_id)
                    redirect_to new_session_path, alert: 'No se pudo iniciar sesión'
                end
            else
                session.delete(:user_id)
                redirect_to new_session_path, alert: 'No se pudo iniciar sesión'
            end
        end
end