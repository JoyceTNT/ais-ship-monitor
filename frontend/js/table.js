// Schiffsliste: eine Tabellenzeile pro Schiff, per DOM-Manipulation erzeugt.

import { shipName, navStatusText, speedText, timeText } from "./format.js";

const tableBody = document.getElementById("ship-table-body");

/**
 * Füllt die Tabelle neu.
 * onRowClick wird mit der MMSI aufgerufen, wenn man auf eine Zeile klickt.
 */
export function showShipsInTable(ships, onRowClick) {
  tableBody.replaceChildren();          // alte Zeilen entfernen

  for (const ship of ships) {
    const row = document.createElement("tr");
    const values = [
      shipName(ship),
      ship.mmsi,
      ship.shipType ?? "–",
      ship.destination ?? "–",
      speedText(ship),
      navStatusText(ship),
      timeText(ship.lastSeen),
    ];
    for (const value of values) {
      const cell = document.createElement("td");
      cell.textContent = value;         // textContent: sicher, kein HTML
      row.append(cell);
    }
    row.addEventListener("click", () => onRowClick(ship.mmsi));
    tableBody.append(row);
  }
}
