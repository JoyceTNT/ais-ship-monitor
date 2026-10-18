// Holt die Schiffsdaten vom Backend (REST-API).

const SHIPS_URL = "/api/ships";

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
