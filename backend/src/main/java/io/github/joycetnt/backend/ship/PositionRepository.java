package io.github.joycetnt.backend.ship;

import org.springframework.data.jpa.repository.JpaRepository;

/**
 * Zugriff auf die Tabelle "positions".
 * Spring Data JPA erzeugt die Methoden (save, findAll, count, ...) automatisch.
 */
public interface PositionRepository extends JpaRepository<Position, Long> {
}
