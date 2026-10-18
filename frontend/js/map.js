// Karte mit Leaflet: ein Punkt pro Schiff an seiner letzten Position.

import { shipName, navStatusText, speedText, timeText, isMoving } from "./format.js";

const BREMERHAVEN = [53.54, 8.58];

// Farben der Punkte (Blau/Orange: auch bei Farbsehschwäche gut unterscheidbar)
const COLOR_MOVING = "#1f77b4";     // fährt (mehr als 0,5 Knoten)
const COLOR_STOPPED = "#ff7f0e";    // steht (liegt fest, vor Anker ...)

let map;                      // die Leaflet-Karte
const markers = new Map();    // MMSI → Punkt auf der Karte

/** Erstellt die Karte im Element mit der id "map". */
export function initMap() {
  map = L.map("map").setView(BREMERHAVEN, 13);
  L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", {
    maxZoom: 19,
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
  }).addTo(map);
  addLegend();
}

/** Legende unten rechts auf der Karte: was die Farben bedeuten. */
function addLegend() {
  const legend = L.control({ position: "bottomright" });
  legend.onAdd = () => {
    const box = document.createElement("div");
    box.className = "legend";
    box.append(
      legendLine(COLOR_MOVING, "Fährt"),
      legendLine(COLOR_STOPPED, "Steht"),
      "Letzte bekannte Position je Schiff",
    );
    return box;
  };
  legend.addTo(map);
}

function legendLine(color, text) {
  const line = document.createElement("div");
  const dot = document.createElement("span");
  dot.className = "legend-dot";
  dot.style.background = color;
  line.append(dot, text);
  return line;
}

/** Zeichnet alle Schiffe neu: alte Punkte entfernen, neue setzen. */
export function showShipsOnMap(ships) {
  markers.forEach((marker) => marker.remove());
  markers.clear();

  for (const ship of ships) {
    const marker = L.circleMarker([ship.lat, ship.lon], {
      radius: 7,
      color: "white",
      weight: 1,
      fillColor: isMoving(ship) ? COLOR_MOVING : COLOR_STOPPED,
      fillOpacity: 0.9,
    });
    marker.bindPopup(popupContent(ship));
    marker.addTo(map);
    markers.set(ship.mmsi, marker);
  }
}

/** Zentriert die Karte auf ein Schiff und öffnet sein Info-Fenster. */
export function focusShip(mmsi) {
  const marker = markers.get(mmsi);
  if (marker) {
    map.setView(marker.getLatLng(), 15);
    marker.openPopup();
  }
}

/** Leaflet muss neu messen, wenn die Karte vorher zugeklappt (unsichtbar) war. */
export function refreshMapSize() {
  map.invalidateSize();
}

/**
 * Inhalt des Info-Fensters. Mit DOM-Elementen und textContent gebaut (nicht mit innerHTML),
 * damit Text aus den Daten nie als HTML ausgeführt werden kann.
 */
function popupContent(ship) {
  const box = document.createElement("div");

  const title = document.createElement("strong");
  title.textContent = shipName(ship);
  box.append(title);

  const lines = [
    `Typ: ${ship.shipType ?? "–"}`,
    `Ziel: ${ship.destination ?? "–"}`,
    `Geschwindigkeit: ${speedText(ship)}`,
    `Status: ${navStatusText(ship)}`,
    `Zuletzt gesehen: ${timeText(ship.lastSeen)}`,
  ];
  for (const text of lines) {
    const line = document.createElement("div");
    line.textContent = text;
    box.append(line);
  }
  return box;
}
