package io.github.joycetnt.backend.ship;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

/**
 * Ein Schiff aus der Tabelle "ships" (statische AIS-Daten: Name, Typ, Zielhafen).
 */
@Entity
@Table(name = "ships")
public class Ship {

    @Id
    private Integer mmsi;          // eindeutige Schiffsnummer = Primärschlüssel

    private String name;
    private String shipType;       // Spalte ship_type (Spring wandelt camelCase automatisch um)
    private String destination;

    // Leerer Konstruktor: JPA braucht ihn, um Objekte aus der Datenbank zu erzeugen
    protected Ship() {
    }

    // Konstruktor für ein neues Schiff (beim Import ist anfangs nur die MMSI bekannt)
    public Ship(Integer mmsi) {
        this.mmsi = mmsi;
    }

    // Getter: Werte von außen lesen
    public Integer getMmsi() {
        return mmsi;
    }

    public String getName() {
        return name;
    }

    public String getShipType() {
        return shipType;
    }

    public String getDestination() {
        return destination;
    }

    // Setter: Werte ändern, wenn eine neue AIS-Nachricht Typ 5 oder 24 ankommt
    public void setName(String name) {
        this.name = name;
    }

    public void setShipType(String shipType) {
        this.shipType = shipType;
    }

    public void setDestination(String destination) {
        this.destination = destination;
    }
}
