package io.github.joycetnt.backend.ship;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * Geschäftslogik rund um Schiffe: verbindet Schiffsdaten und Positionen für die API.
 */
@Service
public class ShipService {

    private final ShipRepository shipRepository;
    private final PositionRepository positionRepository;

    public ShipService(ShipRepository shipRepository, PositionRepository positionRepository) {
        this.shipRepository = shipRepository;
        this.positionRepository = positionRepository;
    }

    /** Alle Schiffe mit ihrer letzten Position, das zuletzt gesehene zuerst. */
    @Transactional(readOnly = true)
    public List<ShipDto> findShipsWithLatestPosition() {
        // Alle Schiffe einmal laden und nach MMSI ablegen, um sie schnell wiederzufinden
        Map<Integer, Ship> shipsByMmsi = new HashMap<>();
        for (Ship ship : shipRepository.findAll()) {
            shipsByMmsi.put(ship.getMmsi(), ship);
        }

        List<ShipDto> result = new ArrayList<>();
        for (Position position : positionRepository.findLatestPerShip()) {
            // Das Schiff existiert immer (Fremdschlüssel in der Datenbank)
            Ship ship = shipsByMmsi.get(position.getMmsi());
            result.add(new ShipDto(
                    ship.getMmsi(), ship.getName(), ship.getShipType(), ship.getDestination(),
                    position.getReceivedAt(), position.getLat(), position.getLon(),
                    position.getSpeed(), position.getCourse(), position.getNavStatus()));
        }

        // Zuletzt gesehene Schiffe zuerst
        result.sort(Comparator.comparing(ShipDto::lastSeen).reversed());
        return result;
    }
}
