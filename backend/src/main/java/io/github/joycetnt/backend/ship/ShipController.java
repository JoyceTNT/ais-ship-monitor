package io.github.joycetnt.backend.ship;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * REST-API für Schiffe. Antwortet auf Anfragen an /api/ships mit JSON.
 */
@RestController
@RequestMapping("/api/ships")
public class ShipController {

    private final ShipService shipService;

    public ShipController(ShipService shipService) {
        this.shipService = shipService;
    }

    /** GET /api/ships: alle Schiffe mit ihrer letzten Position. */
    @GetMapping
    public List<ShipDto> getShips() {
        return shipService.findShipsWithLatestPosition();
    }
}
