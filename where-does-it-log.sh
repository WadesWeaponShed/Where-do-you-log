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
  mgmt_cli -d $I -r true show simple-gateways limit 500 details-level full --format json |jq --raw-output '.objects[] | (.name + "," + . "send-logs-to-server"[] + ",")' >>$CMA_NAME-gateway-logging-location.csv
done

rm CMA-IP.txt
printf "\nYou now have logging location files for each CMA. These are CSV files for easy import to Excel.\n"
