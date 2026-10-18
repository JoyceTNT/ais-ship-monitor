// Hilfsfunktionen, um Werte lesbar anzuzeigen (von Karte und Tabelle gemeinsam genutzt).

// Navigationsstatus laut AIS-Standard
const NAV_STATUS = {
  0: "Fährt mit Maschine",
  1: "Vor Anker",
  2: "Manövrierunfähig",
  3: "Eingeschränkt manövrierfähig",
  4: "Tiefgangbehindert",
  5: "Festgemacht",
  6: "Auf Grund",
  7: "Beim Fischen",
  8: "Segelt",
};

/** Name des Schiffes, oder die MMSI, falls der Name (noch) unbekannt ist. */
export function shipName(ship) {
  return ship.name ?? `MMSI ${ship.mmsi}`;
}

/** Navigationsstatus als Text. */
export function navStatusText(ship) {
  return NAV_STATUS[ship.navStatus] ?? "Unbekannt";
}

/** Geschwindigkeit in Knoten, z. B. "11.5 kn". */
export function speedText(ship) {
  return ship.speed === null ? "–" : `${ship.speed} kn`;
}

/** Zeit im deutschen Format, z. B. "17.10.2026, 13:34:22". */
export function timeText(isoTime) {
  return new Date(isoTime).toLocaleString("de-DE");
}

/** Fährt das Schiff gerade? (mehr als 0,5 Knoten) */
export function isMoving(ship) {
  return ship.speed !== null && ship.speed > 0.5;
}
