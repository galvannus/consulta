import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="modals"
export default class extends Controller {
  connect() {}
  close(e) {
    // Prevent default action
    e.preventDefault();
    // Remove from parent
    const modal = document.getElementById("modal_cancel");
    modal.innerHTML = "";

    // Remove the src attribute from the modal
    modal.removeAttribute("src");

    // Remove complete attribute
    modal.removeAttribute("complete");
  }

  afterSubmitForm(e) {
    e.preventDefault();

    let getId = e.target.id.split("_");

    const form = document.getElementById(`form-cancel-appointment-${getId[1]}`);
    const observacion = document.querySelector(`#cancel_observacion_id_${getId[1]}`);
    
    let observacionValidado = false;

    if( observacion.value.trim() !== ""){
      observacionValidado = true;
    }
    
    if( observacionValidado ){
      form.submit();
    }
  }

  beforeSubmitWithPassword(e) {
    e.preventDefault();

    let getId = e.target.id.split("_");

    const form = document.getElementById(`form-cancel-appointment-${getId[1]}`);
    const observacion = document.querySelector(`#cancel_observacion_id_${getId[1]}`);
    const user = document.getElementById(`cancel_medic_user_${getId[1]}`);
    const password = document.getElementById(`cancel_password_${getId[1]}`);
    
    let observacionValidado = false;
    let withUser = false;
    let withPassword = false;

    if( observacion.value.trim() !== ""){
      observacionValidado = true;
    }
    if( user.value.trim() !== ""){
      withUser = true;
    }
    if( password.value.trim() !== ""){
      withPassword = true;
    }
    
    if( observacionValidado && withUser && withPassword ){
      form.submit();
    }
  }

  closeModal(e) {
    let getId = e.target.id.split("_");
    var btn = document.getElementById(`modal-personalized-cancel${getId[1]}`);
    const observacion = document.querySelector(`#cancel_observacion_id_${getId[1]}`);

    observacion.value = "";
    btn.style.display = "none";
  }
  openModal(e) {
    let getId = e.target.id.split("_");
    var btn = document.getElementById(`modal-personalized-cancel${getId[1]}`);
    btn.style.display = "block";
  }
}