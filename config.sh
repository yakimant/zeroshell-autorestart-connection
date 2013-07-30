DATE="/bin/date +%d/%m/%y%t%T"
ECHO="/bin/echo"
SLEEP="/bin/sleep"
GREP="/bin/grep"
DEV_NULL="/dev/null"
PING="/bin/ping"

PPP_START="/root/kerbynet.cgi/scripts/3Gconnect"
PPP_STOP="/root/kerbynet.cgi/scripts/3Gconnect_stop"
GW_ENABLE="/root/kerbynet.cgi/scripts/nb_enablegw"
GW_STATUS="/root/kerbynet.cgi/scripts/nb_statusgw"

GATEWAYS_PATH="/var/register/system/net/nb/Gateways"

#PPP_LIST=(`ifconfig -a | grep ppp | awk '{print $1}' | xargs`);
PPP_LIST=(ppp1)
PPP_STATUS_PING_COUNT=10
TEST_IP="8.8.8.8"

GW_LOG_FILE="/DB/gw.log"
PING_LOG_FILE="/DB/ping.log"

function get_gw_from_ppp {
	grep -l $1 $GATEWAYS_PATH/*/Interface | awk -F/ '{print $8  }'
}

function enable_gw_for_ppp {
	gw=$(get_gw_from_ppp $1)
	$GW_ENABLE $gw yes
}

function disable_gw_for_ppp {
	gw=$(get_gw_from_ppp $1)
	$GW_ENABLE $gw no
}

function get_gw_status_for_ppp {
	gw=$(get_gw_from_ppp $1)
	$GW_STATUS $gw | grep font |  sed -n 's/<\/font>//p' | sed -n 's/<font.*>//p'
}

function stop_ppp {
	$PPP_STOP $1
}

function start_ppp {
	$PPP_START $1 &
}

function restart_ppp {
	stop_ppp $1
	start_ppp $1
}

function get_ppp_status {
	$PING -q -c$PPP_STATUS_PING_COUNT -I $1 $TEST_IP > $DEV_NULL
	echo $?
}