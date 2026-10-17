package io.github.joycetnt.backend.ais;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import io.github.joycetnt.backend.ship.Position;
import io.github.joycetnt.backend.ship.PositionRepository;
import io.github.joycetnt.backend.ship.Ship;
import io.github.joycetnt.backend.ship.ShipRepository;

/**
 * Liest regelmäßig die Datei mit den AIS-Daten und speichert neue Zeilen in der Datenbank.
 * Es bleiben höchstens "maxPositions" Positionen gespeichert: die ältesten werden gelöscht.
 * So zeigt die Anwendung auch nach einer Empfangspause immer die zuletzt bekannten Schiffe.
 */
@Component
@ConditionalOnProperty(name = "ais.import.enabled", havingValue = "true", matchIfMissing = true)
public class AisImporter {

    private static final Logger log = LoggerFactory.getLogger(AisImporter.class);

    private final AisParser parser;
    private final ShipRepository shipRepository;
    private final PositionRepository positionRepository;
    private final Path dataFile;
    private final long maxPositions;

    // Zeit der zuletzt importierten Zeilen (null = noch nichts importiert)
    private LocalDateTime lastImported;

    // Spring ruft diesen Konstruktor auf und übergibt die benötigten Objekte und Einstellungen
    public AisImporter(AisParser parser,
                       ShipRepository shipRepository,
                       PositionRepository positionRepository,
                       @Value("${ais.import.file}") String dataFile,
                       @Value("${ais.import.max-positions}") long maxPositions) {
        this.parser = parser;
        this.shipRepository = shipRepository;
        this.positionRepository = positionRepository;
        this.dataFile = Path.of(dataFile);
        this.maxPositions = maxPositions;
    }

    /** Wird automatisch alle paar Sekunden aufgerufen (Abstand: ais.import.interval). */
    @Scheduled(fixedDelayString = "${ais.import.interval}")
    @Transactional
    public void importNewLines() {
        List<String> lines;
        try {
            lines = Files.readAllLines(dataFile);
        } catch (IOException e) {
            log.warn("AIS-Datei kann nicht gelesen werden: {}", dataFile.toAbsolutePath());
            return;
        }

        // Beim ersten Durchlauf: dort weitermachen, wo die Datenbank aufgehört hat
        if (lastImported == null) {
            lastImported = positionRepository.findLatestReceivedAt();
        }

        // Neueste Sekunde in der Datei suchen. Zeilen dieser Sekunde können noch unvollständig sein,
        // sie werden deshalb erst beim nächsten Durchlauf importiert.
        LocalDateTime newest = null;
        for (String line : lines) {
            LocalDateTime time = parser.parseTime(line);
            if (time != null && (newest == null || time.isAfter(newest))) {
                newest = time;
            }
        }
        if (newest == null) {
            return;                                     // Datei leer
        }

        Map<Integer, Ship> ships = new HashMap<>();     // in diesem Durchlauf geänderte Schiffe
        List<Position> positions = new ArrayList<>();
        LocalDateTime imported = lastImported;

        for (String line : lines) {
            LocalDateTime time = parser.parseTime(line);
            if (time == null                                            // Zeile unlesbar
                    || (lastImported != null && !time.isAfter(lastImported))  // schon importiert
                    || !time.isBefore(newest)) {                        // neueste Sekunde: nächstes Mal
                continue;
            }

            ShipInfo info = parser.parseShipInfo(line);
            if (info != null) {
                updateShip(findShip(info.mmsi(), ships), info);
            }

            Position position = parser.parsePosition(line);
            if (position != null) {
                findShip(position.getMmsi(), ships);    // Schiff muss existieren (Fremdschlüssel)
                positions.add(position);
            }

            if (imported == null || time.isAfter(imported)) {
                imported = time;
            }
        }

        // Zuerst die Schiffe speichern (und sofort in die Datenbank schreiben), dann die Positionen
        shipRepository.saveAllAndFlush(ships.values());
        positionRepository.saveAll(positions);
        lastImported = imported;

        int deleted = deleteOldestPositions();

        if (!positions.isEmpty() || deleted > 0) {
            log.info("Import: {} neue Positionen, {} Schiffe aktualisiert, {} alte Positionen gelöscht",
                    positions.size(), ships.size(), deleted);
        }
    }

    /**
     * Behält nur die neuesten "maxPositions" Positionen.
     * Die ids werden in Importreihenfolge vergeben (neuere Position = höhere id),
     * deshalb genügt es, alle ids bis "höchste id - maxPositions" zu löschen.
     */
    private int deleteOldestPositions() {
        Long maxId = positionRepository.findMaxId();
        if (maxId == null || maxId <= maxPositions) {
            return 0;                                   // noch nicht genug Positionen
        }
        return positionRepository.deleteUpToId(maxId - maxPositions);
    }

    /** Sucht ein Schiff: zuerst unter den schon geladenen, dann in der Datenbank, sonst wird es neu angelegt. */
    private Ship findShip(Integer mmsi, Map<Integer, Ship> ships) {
        return ships.computeIfAbsent(mmsi,
                key -> shipRepository.findById(key).orElseGet(() -> new Ship(key)));
    }

    /** Übernimmt nur die Werte, die in der Nachricht vorhanden sind. */
    private void updateShip(Ship ship, ShipInfo info) {
        if (info.name() != null) {
            ship.setName(info.name());
        }
        if (info.shipType() != null) {
            ship.setShipType(info.shipType());
        }
        if (info.destination() != null) {
            ship.setDestination(info.destination());
        }
    }
}
