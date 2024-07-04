import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="modals"
export default class extends Controller {
  connect() {}
  close(e) {
    // Prevent default action
    e.preventDefault();
    // Remove from parent
    const modal = document.getElementById("modal_services");
    modal.innerHTML = "";

    // Remove the src attribute from the modal
    modal.removeAttribute("src");

    // Remove complete attribute
    modal.removeAttribute("complete");
  }

  createService(){
    //let categoria = event.target.value;
    let branchOffice = document.getElementById("branchOffice").value;
    let details = document.getElementById("details");
    let startDate = document.getElementById("fechaInicial").value;
    let finalDate = document.getElementById("fechaFinal").value;
    let type = "1";
    let separado = document.getElementById("separado");
    let separadoPorPunto = "";

    
    let preloader = document.getElementById("preloader");
    preloader.classList.remove("hidden");
    /*
    let clasesPreloader = table.classList;
    let activeHidden = 0;
    for (let index = 0; index < clasesPreloader.length; index++) {
      
      if(clasesPreloader[index] == "hidden"){
        activeHidden = 1;
      }
    }
    if(activeHidden == 1){
      table.classList.remove("hidden");
    }else{
      table.classList.add("hidden");
    }*/

    if(separado.checked){
      separadoPorPunto = "1";
    }

    if(!details.checked){
      type = "2"
    }

    let xmlhttp=new XMLHttpRequest();
    xmlhttp.onreadystatechange=function() {

      //Si devuelve estado ok
      if (this.readyState==4 && this.status==200) {

        //alert(innerHTML=this.responseText);
        //Agrega lo que viene de respuesta al elemento con id text_table
        //document.getElementById("text_table").innerHTML=this.responseText;
        alert("Agregado correctamente.");
      }
    }

    xmlhttp.open("GET","localhost:3000/medico?servicio_id=" + branchOffice + "&type="+ type,true);
    xmlhttp.send();
  }
}