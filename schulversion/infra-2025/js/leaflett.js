let map;
let shipMarkers = [];

function initMap() {
  map = L.map('map').setView([53.54, 8.5835], 12);
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    minZoom: 8,
    maxZoom: 19,
    attribution: '<a href="https://openstreetmap.org">OpenStreetMap</a>'
  }).addTo(map);
  updateMapData();
}

function updateMapData() {
  if (!map) return;
  shipMarkers.forEach(marker => map.removeLayer(marker));
  shipMarkers = [];

  const xhr = new XMLHttpRequest();
  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4 && xhr.status === 200) {
      const lines = xhr.responseText.trim().split("\n");
      lines.forEach(line => {
        const parts = line.split(",");
        if (parts.length === 4) {
          const zeit = parts[0];
          const mmsi = parts[1];
          const lng = parseFloat(parts[2]);
          const lat = parseFloat(parts[3]);
          if (!isNaN(lat) && !isNaN(lng)) {
            const marker = L.marker([lat, lng])
              .addTo(map)
              .bindPopup(`MMSI: ${mmsi}<br>ZEIT: ${zeit}`);
            shipMarkers.push(marker);
          }
        }
      });
    }
  };

  xhr.open("GET", "/cgi-bin/schiffe/letzte_nachricht.sh", true);
  xhr.send();
}

