class Appointment < ApplicationRecord
  belongs_to :medical_session
  belongs_to :user
  has_many :service_acquireds, dependent: :destroy
  has_many :services, through: :service_acquireds

  def broadcast
    #appointments_createds = Appointment.where("medical_session_id = ?",self)
    #Append appointment to Sucursal
    broadcast_append_to "appointments#{self.medical_session_id}", partial: 'appointments/appointment', 
    locals: { appointment: self, session_consulta: self.medical_session_id }
    
    #Append appointment to Medico
    broadcast_append_to "appointments-medico#{self.medical_session_id}", partial: 'appointments/sidebar_appointment', 
    locals: { appointment: self, session_consulta: self.medical_session_id }

    #Change btn Finalizar Sesión
    broadcast_replace_to "appointments#{self.medical_session_id}", 
      target: "appointment_btn_finish#{self.medical_session_id}",
      partial: 'appointments/buttons_finish_session/btn_normal_finish',
      locals: { session_consulta: self.medical_session_id }
  end

  def broadcast_appointment_modified
    broadcast_replace_to "appointments#{self.medical_session_id}", target: self, partial: 'appointments/appointment', 
    locals: { appointment: self, session_consulta: self.medical_session_id }
  end

  def broadcast_remove_appointment
    #broadcast_replace_to "appointments#{self.medical_session_id}", target: self, partial: 'appointments/appointment', 
    #locals: { appointment: self, session_consulta: self.medical_session_id }
    broadcast_remove_to "appointments#{self.medical_session_id}"
    broadcast_remove_to "appointments-medico#{self.medical_session_id}"
    broadcast_remove_to "medic_panel_#{self.id}", target: "panel_#{self.id}"
  end

  def broadcast_canceled_appointment
    #Remove from sucursal
    broadcast_remove_to "appointments#{self.medical_session_id}"
    #Remove from medic Slidebar
    broadcast_remove_to "appointments-medico#{self.medical_session_id}"
    #Remove from medic Panel
    broadcast_remove_to "medic_panel_#{self.id}", target: "panel_#{self.id}"
    #Append canceled appointment to Medico
    broadcast_append_to "appointments-medico#{self.medical_session_id}", partial: 'appointments/sidebar_appointment', 
    locals: { appointment: self, session_consulta: self.medical_session_id }
  end

  def broadcast_btn_finish
    broadcast_replace_to "appointments#{self.medical_session_id}", 
      target: "appointment_btn_finish#{self.medical_session_id}",
      partial: 'appointments/buttons_finish_session/btn_reload_finish',
      locals: { session_consulta: self.medical_session_id }
  end

end