#!/bin/bash
source /opt/CPshrd-R80/tmp/.CPprofile.sh
printf "\nGathering CMA Info\n"
for CMA_NAME in $($MDSVERUTIL AllCMAs);
do
  $MDSVERUTIL CMAIp  -n $CMA_NAME >> CMA-IP.txt
done

printf "\nBuilding Log Location Lists. Be Patient...\n"
for I in $(cat CMA-IP.txt)
do
  for M in $(seq 0 50 500)
  do
  mgmt_cli -d $I -r true show simple-gateways limit 50 offset $M details-level full --format json |jq --raw-output '.objects[] | (.name + "," + . "send-logs-to-server"[] + ",")' >>$I-gateway-logging-location.csv
  done
done

rm CMA-IP.txt
printf "\nYou now have logging location files for each CMA. These are CSV files for easy import to Excel.\n"
