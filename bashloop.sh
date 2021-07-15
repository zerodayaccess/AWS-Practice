#!/bin/bash

#Push Up Timer with Sound Reminder
#@zerodayaccess

runtime="5 minute"
endtime=$(date -ud "$runtime" +%s)

while [[ $(date -u +%s) -le $endtime ]]
do
    echo -e "\a"
    echo "Do Pushups: `date +%H:%M:%S`"
    echo "Rest for 15 seconds"
    sleep 15
done
