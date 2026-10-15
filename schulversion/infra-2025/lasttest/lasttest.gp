set terminal pngcairo size 2048,1024 font 'Verdana,32'
set output 'lasttest.png'

set title 'Visualisierung'
set xrange [0:50]
set yrange [0:6000]
set xlabel "Gleichzeitig gestarteten Prozesse"
set ylabel "Anzahl von Requests"


plot 'lasttest.dat' using 1:2 with linespoints title "Requests pro Sekunde" pt 7 ps 1


