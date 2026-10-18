# AIS Ship Monitor

Webanwendung, die Schiffsbewegungen vor Bremerhaven auf einer Karte und in einer Liste anzeigt. Grundlage sind AIS-Daten: Funkmeldungen, mit denen Schiffe regelmäßig ihre Position, Geschwindigkeit, ihren Namen und ihr Ziel senden.

Das Projekt ist aus zwei Teamprojekten an der Hochschule Bremerhaven entstanden: *Infrastruktur* (2025, AIS-Daten mit Bash und CGI) und *Vernetzte Systeme* (2024, Docker-Infrastruktur mit HAProxy, Tomcat, MariaDB und Redis). Ich habe beide eigenständig zu einer Anwendung zusammengeführt und auf Spring Boot, Docker Compose und ein JavaScript-Frontend umgestellt.

**Live-Demo:** https://joycetnt.github.io/ais-ship-monitor/

Die Live-Demo zeigt das Frontend mit festen Beispieldaten (Stand: 18.10.2026), da GitHub Pages keine Server ausführt. In der vollständigen Version kommen die Daten laufend vom AIS-Empfänger über das Spring-Boot-Backend aus der MariaDB-Datenbank. Die Demo wird bei jedem Push automatisch per GitHub Actions veröffentlicht.

## Funktionen

- Laufender Empfang der AIS-Meldungen über einen systemd-Dienst, mit automatischem Neuverbinden
- Import der Meldungen in MariaDB alle 10 Sekunden, ohne doppelte Einträge; die 50 000 neuesten Positionen bleiben gespeichert
- REST-API mit allen Schiffen und ihrer letzten Position (`GET /api/ships`)
- Karte (Leaflet, OpenStreetMap): ein Punkt pro Schiff, farbig nach „fährt“ / „steht“, mit Info-Fenster
- Schiffsliste mit Name, Typ, Ziel, Geschwindigkeit und Status; ein Klick zeigt das Schiff auf der Karte
- Akkordeon-Oberfläche, automatische Aktualisierung alle 30 Sekunden
- Start der Datenbank und des Backends mit einem Befehl (Docker Compose)

## Technologien

| Bereich | Technologie |
|---|---|
| Frontend | JavaScript (ES-Module, `fetch`, DOM), HTML, CSS, Leaflet |
| Backend | Java 25, Spring Boot 4 (Spring Web, Spring Data JPA), Maven |
| Datenbank | MariaDB 12.3 |
| Datenempfang | Bash, SSH, systemd |
| Werkzeuge | Docker, Docker Compose, JUnit, Git, GitHub Actions (CI/CD), GitHub Pages |

## Architektur

```
AIS-Server der Hochschule ──SSH──► collector (systemd) ──► daten/ais-daten.txt
                                                                  │
                                                                  ▼  alle 10 s
Browser (Karte, Liste) ──HTTP/JSON──► Spring Boot (Port 8081) ──JPA──► MariaDB
                                       └──────── Docker Compose ────────┘
```

Der Sammler schreibt die Meldungen in eine Textdatei (höchstens 50 000 Zeilen). Das Backend liest neue Zeilen, wandelt sie in Schiffe und Positionen um und speichert sie in der Datenbank. Die Webseite wird vom selben Server ausgeliefert und fragt die Daten über die REST-API ab.

## Projektstruktur

```
ais-ship-monitor/
├── collector/           Empfang der AIS-Daten (Bash-Skript + systemd-Dienst)
├── database/
│   └── schema.sql       Tabellen ships und positions
├── backend/             Spring Boot
│   ├── Dockerfile
│   └── src/main/java/io/github/joycetnt/backend/
│       ├── ais/         Parser und Import der AIS-Meldungen
│       └── ship/        Entitäten, Repositories, Service, REST-Controller
├── frontend/            Webseite
│   ├── js/              main, api, map, table, format
│   └── demo/ships.json  Beispieldaten für die Live-Demo
├── schulversion/        Ursprüngliche Hochschulprojekte (bereinigt)
├── docker-compose.yml   MariaDB + Backend
└── .github/workflows/   Veröffentlichung der Live-Demo
```

## Installation und Start

**Voraussetzungen:** Docker mit Docker Compose

```bash
git clone https://github.com/JoyceTNT/ais-ship-monitor.git
cd ais-ship-monitor
cp .env.example .env          # anschließend eigene Passwörter in .env eintragen
docker compose up -d --build
```

Die Anwendung läuft danach auf http://localhost:8081/.

Der Sammler (`collector/`) braucht einen Zugang zum AIS-Server der Hochschule. Ohne diesen Zugang startet die Anwendung trotzdem, zeigt aber keine Schiffe an. Die Oberfläche mit Beispieldaten lässt sich mit http://localhost:8081/?demo ansehen.

**Tests:** `cd backend && ./mvnw test` (benötigt die laufende Datenbank)

## API

| Methode | Route | Beschreibung |
|---|---|---|
| GET | `/api/ships` | Alle Schiffe mit ihrer letzten bekannten Position, neueste zuerst |

Beispielantwort:

```json
[
  {
    "mmsi": 211595610,
    "name": "BREMERHAVEN",
    "shipType": "Passenger",
    "destination": "BREMERHAFEN-BLEXEN",
    "lastSeen": "2026-10-18T10:48:34",
    "lat": 53.538832,
    "lon": 8.570293,
    "speed": 7.3,
    "course": 3.9,
    "navStatus": 0
  }
]
```

## Weiterentwicklung gegenüber der Schulversion

| Schulversion | Aktuelle Version |
|---|---|
| Bash-Skripte über CGI liefern Text, der im Browser zerlegt wird | REST-API mit Spring Boot, Antworten in JSON |
| SQL-Befehle aus Benutzereingaben zusammengesetzt (SQL-Injection möglich) | Spring Data JPA mit vorbereiteten Anfragen |
| Eine Tabelle mit Zeit, MMSI und Koordinaten als Text | Zwei Tabellen (Schiffe, Positionen) mit Fremdschlüssel, Indizes und passenden Datentypen; zusätzlich Name, Typ, Ziel, Geschwindigkeit und Status |
| Empfang mit `nohup` und einem Überwachungsskript | systemd-Dienst mit automatischem Neustart |
| Tabellenzeilen mit `innerHTML`, `XMLHttpRequest` | DOM mit `textContent` (Schutz vor XSS), `fetch` und `async/await`, ES-Module |
| Ein Dockerfile und Skripte pro Container | Docker Compose, Healthcheck, mehrstufiges Dockerfile, Backend ohne root-Rechte |
| Passwörter fest im Code | Konfiguration über `.env`, eigener Datenbankbenutzer mit minimalen Rechten |
| Keine automatischen Tests | Unit-Tests für den AIS-Parser (JUnit) |

## Geplant

- Login mit gehashten Passwörtern und Sitzungen in Redis
- Warteschlange in Redis zwischen Sammler und Import
- HAProxy als Load Balancer vor zwei Backend-Instanzen
- Warnung, wenn keine neuen Daten mehr ankommen
- Lasttests mit k6 (vorher/nachher)
