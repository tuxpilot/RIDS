#!/bin/bash

gpio_piezo_number="${2}"

alterna_secondes=$(echo "${1}" | awk -F '_' '{ print $2 }')
alterna_end=$((SECONDS+"${alterna_secondes}"))
while [ $SECONDS -lt $alterna_end ]
  do	gpio -g write "${gpio_piezo_number}" 1
		sleep 0.6
		gpio -g write "${gpio_piezo_number}" 0
		sleep 0.6
done