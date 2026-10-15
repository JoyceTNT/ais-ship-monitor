set terminal pngcairo enhanced font "Arial,12"
set output 'cpu_usage.png'
set title "CPU-Auslastung über die Zeit"
set xlabel "Verstrichene Sekunden"
set ylabel "CPU (%)"
set grid
set xtics 20
set datafile separator comma 

# Plot-Befehl (korrekt formatiert)
plot \
  "docker_usage.csv" using 1:2 title "MariaDB" with lines lw 2, \
  '' using 1:3 title "Tomcat" with lines lw 2
