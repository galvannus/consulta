class Authentication::SessionsController < ApplicationController
    skip_before_action :protect_pages

    def new
    end

    def create
        user = User.find_by("username = :username", { username: params[:username] })
        currentDate = DateTime.now
        currentDate = currentDate.strftime("%Y/%m/%d")
        
        if user&.authenticate(params[:password])#Realiza authenticate, solo si @user existe &
            session[:user_id] = user.id
            
            if user.user_type.nombre == "sucursal" || user.user_type.nombre == "medico"
                medicalSession = MedicalSession.joins(:user_medical_sessions).where("DATE(created_at) = ? 
                AND estado = ? AND user_medical_sessions.user_id = ? ",
                currentDate,0,user.id).limit(1)

                #medicalSession = MedicalSession.joins(:user_medical_sessions).where("DATE(created_at) = ? 
                #AND estado = ? AND medical_sessions.id = user_medical_sessions.medical_session_id 
                #AND user_medical_sessions.user_id = ? ",
                #currentDate,0,@user.id)

                #Book.where(created_at: (Time.now.midnight - 1.day)..Time.now.midnight)
                #SELECT * FROM books WHERE (books.created_at BETWEEN '2008-12-21 00:00:00' AND '2008-12-22 00:00:00')
                
                if medicalSession.empty? && user.user_type.nombre == "sucursal"
                    redirect_to new_medical_session_path, notice: 'Se inicio sesión.'
                elsif medicalSession.empty? && user.user_type.nombre == "medico"
                    #redirect_to session_path(@user.id), method: :delete, notice: 'No se ha iniciado sesión en farmacia.'
                    redirect_to reports_path, notice: 'Se inicio sesión.'
                elsif user.user_type.nombre == "sucursal"
                    session[:medical_session_id] = medicalSession[0].id
                    redirect_to sucursal_path, notice: 'Se inicio sesión.'
                elsif user.user_type.nombre == "medico"
                    session[:medical_session_id] = medicalSession[0].id
                    redirect_to medico_path, notice: 'Se inicio sesión.'
                end
            else
                redirect_to permissions_path, alert: 'Se inicio sesión.'
            end
            
        else
            redirect_to new_session_path, alert: 'No se pudo iniciar sesión'
            #render :new, status: :unprocessable_entity
        end
        #@user = User.new(user_params)

        #if @user.save
        #    redirect_to permissions_path, notice: 'Usuario Creado.'
        #else
        #    render :new, status: :unprocessable_entity
        #end
    end

    def destroy
        session.delete(:user_id)

        redirect_to permissions_path, notice: 'Se cerro la sesión correctamente.'
    end

    #private

    #def user_params
    #    params.require(:user).permit(:nombre, :apellido_paterno, :apellido_materno, :email, :username, :password, :user_type_id)
    #end
end