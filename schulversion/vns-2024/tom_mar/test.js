import http from "k6/http";
import { check, sleep } from "k6";

export let options = {
  vus: 1000,           // 1000 virtuelle Benutzer
  duration: "1m",      // Testdauer: 1 Minute
};

export default function () {
  // Erzeuge dynamische Testdaten
  let payload = {
    email: `user_${__VU}_${Math.floor(Math.random()*10000)}@example.com`,
    passwort: "password123",
    benutzername: `user_${__VU}_${Math.floor(Math.random()*10000)}`,
    adresse: "Teststraße 1",
    postleitzahl: "12345",
    stadt: "Teststadt"
  };

  // Konvertiere die Daten in einen URL-kodierten String
  let body = Object.keys(payload)
    .map(key => `${encodeURIComponent(key)}=${encodeURIComponent(payload[key])}`)
    .join("&");

  let params = { headers: { "Content-Type": "application/x-www-form-urlencoded" } };

  // Sende eine POST-Anfrage an deinen /register-Endpunkt
  let res = http.post("http://172.27.0.3:8080/myapp/register", body, params);
  check(res, { "Status 200": (r) => r.status === 200 });
  sleep(1);
}

