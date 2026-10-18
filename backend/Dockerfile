# Baut das Spring-Boot-Backend in zwei Stufen:
# 1. "build": kompiliert den Code mit dem JDK zu einer .jar-Datei
# 2. Laufzeit: nur die .jar mit dem kleineren JRE (ohne Compiler, ohne Quellcode)

FROM eclipse-temurin:25-jdk AS build
WORKDIR /app

# Erst nur Maven-Dateien kopieren und Abhängigkeiten laden:
# Docker merkt sich diesen Schritt und wiederholt ihn nur, wenn sich pom.xml ändert
COPY mvnw pom.xml ./
COPY .mvn .mvn
RUN ./mvnw -q dependency:go-offline

# Dann den Quellcode kopieren und bauen (Tests laufen lokal mit ./mvnw test, sie brauchen die Datenbank)
COPY src src
RUN ./mvnw -q package -DskipTests

FROM eclipse-temurin:25-jre
WORKDIR /app

# Nicht als root laufen (geringste Rechte)
RUN useradd --system app
USER app

COPY --from=build /app/target/*.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]
