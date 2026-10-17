-- Tabellen des AIS-Ship-Monitors.
-- Wird beim ersten Start des MariaDB-Containers automatisch ausgeführt.

-- Statische Schiffsdaten (aus den AIS-Nachrichtentypen 5 und 24)
CREATE TABLE ships (
  mmsi        INT UNSIGNED PRIMARY KEY,   -- eindeutige Schiffsnummer (9 Ziffern)
  name        VARCHAR(20),
  ship_type   VARCHAR(60),                -- z. B. "Cargo", "Passenger"
  destination VARCHAR(20)                 -- Zielhafen
);

-- Positionsmeldungen (aus den AIS-Nachrichtentypen 1, 2, 3 und 18)
CREATE TABLE positions (
  id          BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  mmsi        INT UNSIGNED NOT NULL,
  received_at DATETIME NOT NULL,          -- Empfangszeit
  lat         DECIMAL(8,6) NOT NULL,      -- Breitengrad
  lon         DECIMAL(9,6) NOT NULL,      -- Längengrad
  speed       DECIMAL(4,1),               -- Geschwindigkeit in Knoten
  course      DECIMAL(4,1),               -- Kurs in Grad
  nav_status  TINYINT UNSIGNED,           -- 0 = fährt mit Maschine, 5 = festgemacht ...
  FOREIGN KEY (mmsi) REFERENCES ships (mmsi) ON DELETE CASCADE,
  INDEX idx_positions_mmsi_time (mmsi, received_at),
  INDEX idx_positions_time (received_at)
);
