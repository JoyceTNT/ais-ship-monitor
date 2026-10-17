package io.github.joycetnt.backend.ais;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import org.junit.jupiter.api.Test;

import io.github.joycetnt.backend.ship.Position;

/**
 * Tests für den AisParser mit echten Zeilen aus daten/ais-daten.txt.
 * Laufen ohne Datenbank und ohne Spring.
 */
class AisParserTest {

    private final AisParser parser = new AisParser();

    @Test
    void liestPositionVonGrossemSchiff() {
        String line = "2026-10-16 08:43:27|3|218172000|0|Under way using engine|nan|11.5|true|8.570285|53.533478|3.6|0|26|0|Not available|false|4080";

        Position p = parser.parsePosition(line);

        assertEquals(218172000, p.getMmsi());
        assertEquals(LocalDateTime.of(2026, 10, 16, 8, 43, 27), p.getReceivedAt());
        assertEquals(new BigDecimal("53.533478"), p.getLat());
        assertEquals(new BigDecimal("8.570285"), p.getLon());
        assertEquals(new BigDecimal("11.5"), p.getSpeed());
        assertEquals(new BigDecimal("3.6"), p.getCourse());
        assertEquals((byte) 0, p.getNavStatus());
    }

    @Test
    void liestPositionVonKleinemBoot() {
        String line = "2026-10-15 17:08:57|18|211692500|0|true|8.585707|53.53444|287.2|511|55|true|458755";

        Position p = parser.parsePosition(line);

        assertEquals(211692500, p.getMmsi());
        assertEquals(new BigDecimal("53.53444"), p.getLat());
        assertEquals(new BigDecimal("287.2"), p.getCourse());
        assertNull(p.getNavStatus());
    }

    @Test
    void kurs360WirdZuNull() {
        String line = "2026-10-15 14:46:53|1|211117380|3|Restricted manoeuverability|nan|0|true|8.575543|53.535767|360|511|52|0|Not available|true|100274";

        assertNull(parser.parsePosition(line).getCourse());
    }

    @Test
    void ungueltigeKoordinatenWerdenIgnoriert() {
        String line = "2026-10-15 14:46:53|1|211117380|3|Moored|nan|0|true|181|91|360|511|52|0|Not available|true|100274";

        assertNull(parser.parsePosition(line));
    }

    @Test
    void schiffsdatenSindKeinePosition() {
        String line = "2026-10-16 09:14:22|5|244890472|9805568|PBPH|ROTRA VENTE|70|Cargo - all ships of this type|121|20|10|10|1|10-14T00:30Z|undefined|10|14|0|30|6.1|DEBRV|0";

        assertNull(parser.parsePosition(line));
    }

    @Test
    void liestSchiffsdatenTyp5() {
        String line = "2026-10-16 09:14:22|5|244890472|9805568|PBPH|ROTRA VENTE|70|Cargo - all ships of this type|121|20|10|10|1|10-14T00:30Z|undefined|10|14|0|30|6.1|DEBRV|0";

        ShipInfo info = parser.parseShipInfo(line);

        assertEquals(new ShipInfo(244890472, "ROTRA VENTE", "Cargo", "DEBRV"), info);
    }

    @Test
    void liestSchiffsdatenTyp24TeilAundB() {
        String partA = "2026-10-15 13:53:20|24|211122240|A|A|MANDALAY";
        String partB = "2026-10-15 14:36:16|24|211122240|B|B|36|Sailing|DB3068|null|SMT<--A|15|174224|7|6|2|2";

        assertEquals(new ShipInfo(211122240, "MANDALAY", null, null), parser.parseShipInfo(partA));
        assertEquals(new ShipInfo(211122240, null, "Sailing", null), parser.parseShipInfo(partB));
    }

    @Test
    void kaputteZeileGibtNull() {
        assertNull(parser.parsePosition("Unsinn"));
        assertNull(parser.parseShipInfo(""));
        assertNull(parser.parseTime("Unsinn"));
    }
}
