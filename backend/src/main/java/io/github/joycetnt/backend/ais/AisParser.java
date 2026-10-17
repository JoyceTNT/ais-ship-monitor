package io.github.joycetnt.backend.ais;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

import org.springframework.stereotype.Component;

import io.github.joycetnt.backend.ship.Position;

/**
 * Zerlegt eine Zeile aus daten/ais-daten.txt und macht daraus eine Position oder Schiffsdaten.
 *
 * Aufbau einer Zeile: Felder durch "|" getrennt.
 * Feld 0 = Empfangszeit, Feld 1 = Nachrichtentyp, Feld 2 = MMSI, danach je nach Typ.
 */
@Component
public class AisParser {

    private static final DateTimeFormatter TIME_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    // Werte, die laut AIS-Standard "nicht verfügbar" bedeuten
    private static final BigDecimal SPEED_NOT_AVAILABLE = new BigDecimal("102.3");
    private static final BigDecimal COURSE_NOT_AVAILABLE = new BigDecimal("360");

    /** Liest die Empfangszeit (Feld 0). Gibt null zurück, wenn sie nicht lesbar ist. */
    public LocalDateTime parseTime(String line) {
        String[] fields = line.split("\\|");
        try {
            return LocalDateTime.parse(fields[0], TIME_FORMAT);
        } catch (DateTimeParseException e) {
            return null;
        }
    }

    /**
     * Macht aus einer Positionsmeldung (Typ 1, 2, 3 oder 18) ein Position-Objekt.
     * Gibt null zurück bei anderen Nachrichtentypen oder ungültigen Koordinaten.
     */
    public Position parsePosition(String line) {
        String[] fields = line.split("\\|");
        String type = fields.length > 1 ? fields[1] : "";

        LocalDateTime time = parseTime(line);
        Integer mmsi = toInteger(field(fields, 2));
        BigDecimal speed;
        BigDecimal lon;
        BigDecimal lat;
        BigDecimal course;
        Byte navStatus;

        switch (type) {
            case "1", "2", "3" -> {             // große Schiffe (Klasse A)
                navStatus = toByte(field(fields, 3));
                speed = toDecimal(field(fields, 6));
                lon = toDecimal(field(fields, 8));
                lat = toDecimal(field(fields, 9));
                course = toDecimal(field(fields, 10));
            }
            case "18" -> {                      // kleine Boote (Klasse B), ohne Navigationsstatus
                navStatus = null;
                speed = toDecimal(field(fields, 3));
                lon = toDecimal(field(fields, 5));
                lat = toDecimal(field(fields, 6));
                course = toDecimal(field(fields, 7));
            }
            default -> {
                return null;                    // keine Positionsmeldung
            }
        }

        // Ohne Zeit, MMSI oder gültige Koordinaten ist die Meldung unbrauchbar
        if (time == null || mmsi == null || !isValidCoordinate(lat, lon)) {
            return null;
        }
        // "Nicht verfügbar" wird in der Datenbank als leerer Wert (NULL) gespeichert
        if (speed != null && speed.compareTo(SPEED_NOT_AVAILABLE) >= 0) {
            speed = null;
        }
        if (course != null && course.compareTo(COURSE_NOT_AVAILABLE) >= 0) {
            course = null;
        }
        return new Position(mmsi, time, lat, lon, speed, course, navStatus);
    }

    /**
     * Liest statische Schiffsdaten aus Typ 5 (Name, Typ, Ziel) oder Typ 24 (Teil A: Name, Teil B: Typ).
     * Gibt null zurück bei anderen Nachrichtentypen.
     */
    public ShipInfo parseShipInfo(String line) {
        String[] fields = line.split("\\|");
        String type = fields.length > 1 ? fields[1] : "";
        Integer mmsi = toInteger(field(fields, 2));
        if (mmsi == null) {
            return null;
        }

        if (type.equals("5")) {
            return new ShipInfo(mmsi, toText(field(fields, 5)), shortType(field(fields, 7)), toText(field(fields, 20)));
        }
        if (type.equals("24") && "A".equals(field(fields, 3))) {
            return new ShipInfo(mmsi, toText(field(fields, 5)), null, null);
        }
        if (type.equals("24") && "B".equals(field(fields, 3))) {
            return new ShipInfo(mmsi, null, shortType(field(fields, 6)), null);
        }
        return null;
    }

    // ---------- Hilfsmethoden ----------

    /** Gibt Feld Nummer i zurück, oder null, wenn die Zeile zu kurz ist. */
    private String field(String[] fields, int i) {
        return i < fields.length ? fields[i].trim() : null;
    }

    private Integer toInteger(String value) {
        try {
            return Integer.valueOf(value);
        } catch (NumberFormatException e) {     // auch bei null
            return null;
        }
    }

    private Byte toByte(String value) {
        try {
            return Byte.valueOf(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private BigDecimal toDecimal(String value) {
        try {
            return new BigDecimal(value);
        } catch (NumberFormatException | NullPointerException e) {
            return null;
        }
    }

    /** Text bereinigen: leere Werte und Platzhalter wie "undefined" werden zu null. */
    private String toText(String value) {
        if (value == null) {
            return null;
        }
        String text = value.replace("@", "").trim();   // "@" = Füllzeichen im AIS-Standard
        if (text.isEmpty() || text.equals("undefined") || text.equals("null") || text.equals("nan")) {
            return null;
        }
        return text;
    }

    /** Schiffstyp kürzen: "Cargo - all ships of this type" wird zu "Cargo". */
    private String shortType(String value) {
        String text = toText(value);
        if (text == null) {
            return null;
        }
        int dash = text.indexOf(" - ");
        return dash > 0 ? text.substring(0, dash) : text;
    }

    private boolean isValidCoordinate(BigDecimal lat, BigDecimal lon) {
        // 91 bzw. 181 bedeutet im AIS-Standard "Position nicht verfügbar"
        return lat != null && lon != null
                && lat.abs().compareTo(new BigDecimal("90")) <= 0
                && lon.abs().compareTo(new BigDecimal("180")) <= 0;
    }
}
