import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect(){
        //alert("Conectado!!");
        //this.element.addEventListener("submit", reset);
    }

    reset(){
        //this.element.reset();
        setTimeout(() => {
            let form = document.getElementById("appointment_form");
            form.reset();
        }, 200);
    }
}