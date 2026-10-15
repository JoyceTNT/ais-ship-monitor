set terminal pngcairo enhanced font "Arial,12"
set output 'cpu_allgemein.png'
set title "CPU-Auslastung über die Zeit"
set xlabel "Verstrichene Sekunden"
set ylabel "CPU (%)"
set grid
set datafile separator comma


plot "cpu_allgemein.csv" using 1:2 with lines title "CPU-Auslastung" lw 2
