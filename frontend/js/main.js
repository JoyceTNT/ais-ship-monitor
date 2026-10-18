// Startpunkt der Seite: verbindet API, Karte, Tabelle und Akkordeon.

import { fetchShips } from "./api.js";
import { initMap, showShipsOnMap, focusShip, refreshMapSize } from "./map.js";
import { showShipsInTable } from "./table.js";

const REFRESH_SECONDS = 30;

const statusText = document.getElementById("status");
const mapSection = document.getElementById("map-section");

/** Lädt die Daten und aktualisiert Karte, Tabelle und Statuszeile. */
async function update() {
  try {
    const ships = await fetchShips();
    showShipsOnMap(ships);
    showShipsInTable(ships, showOnMap);
    const time = new Date().toLocaleTimeString("de-DE");
    statusText.textContent = `${ships.length} Schiffe · aktualisiert um ${time}`;
  } catch (error) {
    statusText.textContent = `Daten konnten nicht geladen werden (${error.message}).`;
  }
}

/** Klick in der Tabelle: Karte aufklappen und auf das Schiff zoomen. */
function showOnMap(mmsi) {
  mapSection.open = true;
  refreshMapSize();
  focusShip(mmsi);
  mapSection.scrollIntoView({ behavior: "smooth" });
}

// Wenn die Karte aufgeklappt wird, muss Leaflet ihre Größe neu berechnen
mapSection.addEventListener("toggle", () => {
  if (mapSection.open) {
    refreshMapSize();
  }
});

initMap();
update();
setInterval(update, REFRESH_SECONDS * 1000);   // regelmäßig neu laden
