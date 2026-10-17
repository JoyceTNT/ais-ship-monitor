package io.github.joycetnt.backend.ais;

/**
 * Statische Schiffsdaten aus einer AIS-Nachricht (Typ 5 oder 24).
 * Felder, die in der Nachricht nicht vorkommen, sind null.
 */
public record ShipInfo(Integer mmsi, String name, String shipType, String destination) {
}
