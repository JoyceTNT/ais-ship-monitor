// Holt die Schiffsdaten vom Backend (REST-API).

// Demo-Modus: auf GitHub Pages läuft kein Backend, dort feste Beispieldaten laden.
// Lokal zum Testen mit http://localhost:8081/?demo
export const DEMO_MODE =
  location.hostname.endsWith("github.io") || new URLSearchParams(location.search).has("demo");

const SHIPS_URL = DEMO_MODE ? "demo/ships.json" : "/api/ships";

/**
 * Lädt alle Schiffe mit ihrer letzten Position.
 * Gibt ein Array von Objekten zurück, z. B. { mmsi, name, lat, lon, speed, ... }.
 */
export async function fetchShips() {
  const response = await fetch(SHIPS_URL);
  if (!response.ok) {
    throw new Error(`Server antwortet mit Status ${response.status}`);
  }
  return response.json();
}
