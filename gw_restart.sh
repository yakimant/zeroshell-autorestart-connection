#! /bin/bash
source /DB/config.sh

for ppp in "${PPP_LIST[@]}"
do
	echo "restart $ppp"
	echo "gw_restart: "`$DATE`" Restarting $ppp manualy/by cron" >> $GW_LOG_FILE
	disable_gw_for_ppp $ppp
done
