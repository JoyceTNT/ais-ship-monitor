package io.github.joycetnt.backend;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

// Startet die ganze Anwendung zum Test, aber ohne AIS-Import (der Test soll keine Daten schreiben)
@SpringBootTest(properties = "ais.import.enabled=false")
class BackendApplicationTests {

	@Test
	void contextLoads() {
	}

}
