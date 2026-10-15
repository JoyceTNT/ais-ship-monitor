function loadSchiffe() {
  const xhr = new XMLHttpRequest();
  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4 && xhr.status === 200) {
      const tbody = document.querySelector("#schiffe-table tbody");
      tbody.innerHTML = ""; 

      const lines = xhr.responseText.trim().split("\n");
      lines.forEach(line => {
        const parts = line.split(",");
        if (parts.length >= 2) {
          const row = document.createElement("tr");
          row.innerHTML = `<td>${parts[0]}</td><td>${parts[1]}</td>`;
          tbody.appendChild(row);
        }
      });
    }
  };

  xhr.open("GET", "/cgi-bin/schiffe/letzte_nachricht.sh", true);
  xhr.send();
}

