import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
    connect() {
        createConsumer().subscriptions.create({ channel: "AppointmentChannel", room: this.element.dataset.appointmentid },{
            received(data) {
                if(data.action === "created"){
                    //location.reload()
                    alert("Conectado");
                }
            }
        })
    }
}