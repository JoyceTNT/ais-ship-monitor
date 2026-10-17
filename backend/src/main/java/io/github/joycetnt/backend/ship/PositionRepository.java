package io.github.joycetnt.backend.ship;

import java.time.LocalDateTime;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

/**
 * Zugriff auf die Tabelle "positions".
 * Spring Data JPA erzeugt die Methoden (save, findAll, count, ...) automatisch.
 */
public interface PositionRepository extends JpaRepository<Position, Long> {

    /** Empfangszeit der neuesten gespeicherten Position (null, wenn die Tabelle leer ist). */
    @Query("SELECT MAX(p.receivedAt) FROM Position p")
    LocalDateTime findLatestReceivedAt();

    /** Höchste vergebene id (null, wenn die Tabelle leer ist). Neuere Positionen haben eine höhere id. */
    @Query("SELECT MAX(p.id) FROM Position p")
    Long findMaxId();

    /** Löscht alle Positionen mit einer id bis einschließlich "maxId". Gibt die Anzahl zurück. */
    @Modifying
    @Query("DELETE FROM Position p WHERE p.id <= :maxId")
    int deleteUpToId(@Param("maxId") long maxId);
}
