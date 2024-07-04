import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="modals"
export default class extends Controller {
  connect() {}
  close(e) {
    // Prevent default action
    e.preventDefault();
    // Remove from parent
    const modal = document.getElementById("modal_finish");
    modal.innerHTML = "";

    // Remove the src attribute from the modal
    modal.removeAttribute("src");

    // Remove complete attribute
    modal.removeAttribute("complete");
  }

  afterSubmitForm(e) {
    e.preventDefault();

    let getId = e.target.id.split("_");
    
    const form = document.getElementById(`form-finish-appointment-${getId[1]}`);
    const venta = document.querySelector(`#venta_generada_${getId[1]}`);
    const atendido = document.querySelector(`#atendido_por_${getId[1]}`);
    let ventaValidado = false;
    let atendidoValidado = false;

    if( venta.value.trim() !== "" && venta.value >= 0){
      ventaValidado = true;
    }
    if( atendido.value.trim() !== ""){
      atendidoValidado = true;
    }
    
    if( ventaValidado && atendidoValidado){
      form.submit();
      /*
      setTimeout(() => {
        
        // Remove from parent
        const modal = document.getElementById("modal_finish");
        modal.innerHTML = "";
  
        // Remove the src attribute from the modal
        modal.removeAttribute("src");
  
        // Remove complete attribute
        modal.removeAttribute("complete");
        
        alert(`ventaValidado ${ventaValidado} atendidoValidado${atendidoValidado}`);
      }, 1000);
      */
    }
  }

  closeModal(e) {
    let getId = e.target.id.split("_");

    var btn = document.getElementById(`modal-personalized${getId[1]}`);
    const venta = document.getElementById(`venta_generada_${getId[1]}`);
    const observacion = document.getElementById(`atendido_por_${getId[1]}`);

    observacion.value = "";
    venta.value = "";
    btn.style.display = "none";
  }
  openModal(e) {
    let getId = e.target.id.split("_");
    var btn = document.getElementById(`modal-personalized${getId[1]}`);
    btn.style.display = "block";
  }
}