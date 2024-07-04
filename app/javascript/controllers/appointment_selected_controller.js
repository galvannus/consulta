import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect(){}

    checkboxSelected(e){
        let checkAppointment = document.getElementById("consulta");
        let checkCortesia = document.getElementById("cortesia");

        if( e.target.id == 'consulta' ){
            if( checkAppointment.checked ){
                checkCortesia.checked = false
            }
        }
        if( e.target.id == 'cortesia' ){
            if( checkCortesia.checked ){
                checkAppointment.checked = false
            }
        }
    }
}