package io.github.joycetnt.backend.ship;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Ein Schiff mit seiner letzten bekannten Position, so wie es die API als JSON zurückgibt.
 * DTO = Data Transfer Object: nur zum Übertragen von Daten, nicht mit der Datenbank verbunden.
 */
public record ShipDto(
        Integer mmsi,
        String name,
        String shipType,
        String destination,
        LocalDateTime lastSeen,     // Empfangszeit der letzten Position
        BigDecimal lat,
        BigDecimal lon,
        BigDecimal speed,
        BigDecimal course,
        Byte navStatus) {
}
