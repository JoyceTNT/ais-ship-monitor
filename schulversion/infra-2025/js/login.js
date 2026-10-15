function sendLoginRequest() {
  let email = document.getElementById("email").value;
  let password = document.getElementById("password").value;

   let xhr= new XMLHttpRequest ()
        xhr.onreadystatechange= function() {
          if(xhr.readyState==4 && xhr.status==200) {
          let myheader= document.getElementById("myheader")
          myheader.innerHTML=xhr.responseText

      document.getElementById("map-section").classList.remove("disabled");
      document.getElementById("tabelle-section").classList.remove("disabled");

      if (typeof initMap === "function") initMap();
      if (typeof loadSchiffe === "function") loadSchiffe();
    }
  };

  xhr.open("GET", "/cgi-bin/login/login.sh?email=" + email + "&password=" + password);
  xhr.send();

  console.log("Zeit ist :" + Date.now());
}

function oncepersecond () {
      let xhr= new XMLHttpRequest ()
        console.log("readyState changed")
        xhr.onreadystatechange= function() {
          if(xhr.readyState==4 && xhr.status==200) {
          console.log("readyState changed"+xhr.readyState)
            console.log(xhr.responseText)
            let myheader= document.getElementByID("myheader")
            myheader.innerHTML=xhr.responseText
      }
  }
    console.log("es ist jetzt" +Date.now() )
      }
      function init() {
        console.log("Hello Infra-2025-l")
        window.setInterval(oncepersecond,1000)
      }
    window.onload= init

