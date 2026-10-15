#!/bin/bash
url="http://localhost:8080/cgi-bin/demo.sh"
Aufrufe="10"

for prozesse in $(seq 0 5 50); do
  start="${EPOCHREALTIME/[.,]}"
  for i in $(seq 1 $prozesse);do
  curl -s -o /dev/null "$url"?t=[1-$Aufrufe] &
  #echo "startet process $i"
done 
wait 
end="${EPOCHREALTIME/[.,]}"
#echo "ready after $((end-start)) ms"
duration=$(( (end-start)/1000 ))
req_ms=$(( (prozesse*Aufrufe)/duration ))
req_sek=$(( req_ms*1000 ))
#echo "$req_sek"
echo " $prozesse $req_sek "  >> lasttest.dat
done

