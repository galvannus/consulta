import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect(){
        
        //this.element.addEventListener("submit", reset);
        
        const element = document.getElementById("appointment_to_scroll");
        let scrollPannel = document.getElementById("scroll-panel");

        if( typeof(element.value) !== "undefined" && element.value !== null && element.value !== "" ){

            let appointment = document.getElementById(`appointment_${element.value}`);
            let appointmentCard = document.getElementById(`card_${element.value}`);
            //appointment.scrollIntoView({ block: "center", behavior: "smooth" });
            
            //appointment.classList.remove('');
            appointmentCard.classList.add('bg-info-subtle');
        
            const y = appointment.getBoundingClientRect().top - appointment.offsetHeight + window.scrollY;
            scrollPannel.scroll({
                top: y,
                behavior: 'smooth'
            });
        }
        
    }
}