#! /bin/bash

PING_DELAY=5

PING="/bin/ping -c1"
DATE="/bin/date +%d/%m/%y%t%T"
ECHO="/bin/echo"
DEV_NULL="/dev/null"
SLEEP="/bin/sleep"

PPPs=(`ifconfig -a | grep ppp | awk '{print $1}' | xargs`);

LOG_FILE="/DB/ping_logger.log"

TEST_IP="8.8.8.8"

while [ 1 ]; do
	out=""
	date=`$DATE`
	for ppp in "${PPPs[@]}"
	do
		$PING -I $ppp $TEST_IP >> $DEV_NULL
		status=$?
		if [ $status -ne 0 ]; then
			out=$out" "$ppp":"$status
		fi
	done
	if [ -n "$out" ]; then
		echo `$DATE`$out >> $LOG_FILE
	fi
	$SLEEP $PING_DELAY
done
