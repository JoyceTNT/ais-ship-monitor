package io.github.joycetnt.backend.ship;

import org.springframework.data.jpa.repository.JpaRepository;

/**
 * Zugriff auf die Tabelle "ships".
 * Spring Data JPA erzeugt die Methoden (save, findById, findAll, ...) automatisch.
 */
public interface ShipRepository extends JpaRepository<Ship, Integer> {
}
