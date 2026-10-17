package io.github.joycetnt.backend.ship;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

/**
 * Eine Positionsmeldung aus der Tabelle "positions" (AIS-Nachrichten Typ 1, 2, 3 und 18).
 */
@Entity
@Table(name = "positions")
public class Position {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)   // die Datenbank vergibt die Nummer (AUTO_INCREMENT)
    private Long id;

    private Integer mmsi;                 // zu welchem Schiff die Position gehört
    private LocalDateTime receivedAt;     // Empfangszeit
    private BigDecimal lat;               // Breitengrad
    private BigDecimal lon;               // Längengrad
    private BigDecimal speed;             // Geschwindigkeit in Knoten
    private BigDecimal course;            // Kurs in Grad
    private Byte navStatus;               // Navigationsstatus (0 = fährt mit Maschine, 5 = festgemacht ...)

    // Leerer Konstruktor: JPA braucht ihn, um Objekte aus der Datenbank zu erzeugen
    protected Position() {
    }

    // Konstruktor für eine neue Position (beim Import), alle Werte außer der id
    public Position(Integer mmsi, LocalDateTime receivedAt, BigDecimal lat, BigDecimal lon,
                    BigDecimal speed, BigDecimal course, Byte navStatus) {
        this.mmsi = mmsi;
        this.receivedAt = receivedAt;
        this.lat = lat;
        this.lon = lon;
        this.speed = speed;
        this.course = course;
        this.navStatus = navStatus;
    }

    // Nur Getter, keine Setter: eine gespeicherte Position ändert sich nie
    public Long getId() {
        return id;
    }

    public Integer getMmsi() {
        return mmsi;
    }

    public LocalDateTime getReceivedAt() {
        return receivedAt;
    }

    public BigDecimal getLat() {
        return lat;
    }

    public BigDecimal getLon() {
        return lon;
    }

    public BigDecimal getSpeed() {
        return speed;
    }

    public BigDecimal getCourse() {
        return course;
    }

    public Byte getNavStatus() {
        return navStatus;
    }
}
