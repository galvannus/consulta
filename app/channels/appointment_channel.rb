class AppointmentChannel < ApplicationCable::Channel

    def subscribed
        stream_from "appointment_#{params[:room]}"
    end
end