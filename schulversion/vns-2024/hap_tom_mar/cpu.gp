set terminal pngcairo enhanced font "Arial,12"
set output 'cpu_usage.png'
set title "CPU-Auslastung über die Zeit"
set xlabel "Verstrichene Sekunden"
set ylabel "CPU (%)"
set grid
set datafile separator comma

plot \
  "docker_usage.csv" using 1:2 title "Tomcat" with lines, \
  '' using 1:3 title "Tomcat2" with lines, \
  '' using 1:4 title "HAProxy" with lines
