#! /bin/bash

source /DB/config.sh

DELAY=10

while [ 1 ]; do
        for ppp in "${PPP_LIST[@]}"
        do
                status=$(get_gw_status_for_ppp $ppp)
                if [ "$status" != "Active" ]; then
                        echo "gw_watcher: "`$DATE`" Gateway for $ppp is disabled" >> $GW_LOG_FILE
                        echo "gw_watcher: "`$DATE`" Enabling gateway for $ppp." >> $GW_LOG_FILE
                        enable_gw_for_ppp $ppp
                fi
        done
        $SLEEP $DELAY
done