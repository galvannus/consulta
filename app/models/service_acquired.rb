class ServiceAcquired < ApplicationRecord
  belongs_to :appointment
  belongs_to :service

  def broadcast_service
    #   # Sends <turbo-stream action="append" target="clearances"><template><div id="clearance_5">Other partial</div></template></turbo-stream>
    #   # to the stream named "identity:2:clearances"
    #   clearance.broadcast_append_to examiner.identity, :clearances, target: "clearances",
    #     partial: "clearances/other_partial", locals: { a: 1 }
    broadcast_append_to "service_acquireds-medico#{self.appointment_id}", partial: 'appointments/service_acquired', 
    locals: { service: self, appointment: self.appointment_id, commit: '1' }
  end

  def broadcast_service_modified
    broadcast_replace_to "service_acquireds-medico#{self.appointment_id}", target: self, partial: 'appointments/service_acquired', 
    locals: { service: self, appointment: self.appointment_id, commit: '1' }
  end

  def broadcast_remove_service
    #   # Sends <turbo-stream action="remove" target="clearance_5"></turbo-stream> to the stream named "identity:2:clearances"
    #   clearance.broadcast_remove_to examiner.identity, :clearances
    broadcast_remove_to "service_acquireds-medico#{self.appointment_id}"
  end
end
