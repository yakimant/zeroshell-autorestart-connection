#! /bin/bash

source /DB/config.sh

PING_DELAY=10
RESTART_DELAY=0

while [ 1 ]; do
        for ppp in "${PPP_LIST[@]}"
        do
                status=$(get_ppp_status $ppp)
                if [ $status -ne 0 ]; then
                        echo "ping_watcher: "`$DATE`" ping failed for $ppp" >> $PING_LOG_FILE
                        echo "ping_watcher: "`$DATE`" Restarting $ppp." >> $PING_LOG_FILE
                        restart_ppp $ppp
                        $SLEEP $RESTART_DELAY
                fi
        done
        $SLEEP $PING_DELAY
done