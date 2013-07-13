#! /bin/bash

PING_DELAY=0
PING_COUNT=10
RESTART_DELAY=0

PPP_LIST=(`ifconfig -a | grep ppp | awk '{print $1}' | xargs`);
PING="/bin/ping -q -c$PING_COUNT"
DATE="/bin/date +%d/%m/%y%t%T"
ECHO="/bin/echo"
SLEEP="/bin/sleep"
GREP="/bin/grep"
DEV_NULL="/dev/null"

PPP_START="/root/kerbynet.cgi/scripts/3Gconnect"
PPP_STOP="/root/kerbynet.cgi/scripts/3Gconnect_stop"
GW_ENABLE="/root/kerbynet.cgi/scripts/nb_enablegw"
GATEWAYS_PATH="/var/register/system/net/nb/Gateways"

LOG_FILE="/DB/ppp_checker.log"

TEST_IP="8.8.8.8"

function get_gw_from_interface {
	grep -l $1 $GATEWAYS_PATH/*/Interface | awk -F/ '{print $8  }'	
}

while [ 1 ]; do
	#ppp_list=(`ifconfig -a | grep ppp | awk '{print $1}' | xargs`);
	#out=""
	for ppp in "${PPP_LIST[@]}"
	do
		#echo pinging $ppp
		$PING -I $ppp $TEST_IP > $DEV_NULL
		status=$?
		if [ $status -ne 0 ]; then
			echo `$DATE`" Restarting $ppp." >> $LOG_FILE
			gw=$(get_gw_from_interface $ppp)
			$GW_ENABLE $gw no
			$PPP_STOP $ppp
			$PPP_START $ppp&
			$SLEEP $RESTART_DELAY
			$GW_ENABLE $gw yes
			$SLEEP $RESTART_DELAY
		fi
	done
	#if [ -n "$out" ]; then
	#	echo $out
	#fi
	$SLEEP $PING_DELAY
done

