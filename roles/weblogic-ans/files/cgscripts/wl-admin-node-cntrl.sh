#!/bin/sh

#  History
# =========
# 08-26-2010    btt     Created
# 09-10-2010    mwo     Adapted for weblogic
# 09-12-2013    mwo     Added bounce function for AF WAS migration
#######################################################################

if [ `whoami` != "webapp" ] ; then
    echo "Command ($0) may only be executed by webapp"
    exit 1
fi

DOMAIN=${1:?"Parameter 1 required: domain"}
SERVER=${2:?"Parameter 2 required:Specify Admin Server or Node Manager: admin|node"}
FUNCTION=${3:?"Parameter 3 required: start|stop|status"}

. /users/mwe/cgscripts/server_control_functions.sh

cd /users/domains

linktest=`readlink $DOMAIN`

if [ $? = 0 ]; then
DOMAIN=$linktest
else
DOMAIN=$DOMAIN
fi

if [ ! -d ${DOMAIN} ] ; then
    ls -ld ${DOMAIN}
    echo "domain (${DOMAIN}) not found"
    exit 2
fi

# check_and_start_all_nm

if [[ "$2" =~ [Aa]dmin ]]; then

case ${FUNCTION} in
    start)
        start_admin_server ${DOMAIN} 
        sleep 3
        status_admin_server  ${DOMAIN} ${DOMAIN}"_adm"
        ;;
    stop)
        stop_admin_server  ${DOMAIN}
        sleep 5
        status_admin_server  ${DOMAIN} ${DOMAIN}"_adm" 
       #echo "Stopped Admin Server for ${DOMAIN}" 
        ;;
    status)
        status_admin_server  ${DOMAIN} ${DOMAIN}"_adm"
        ;;
    *)
        echo "Invalid function: " ${FUNCTION}
        ;;
esac

elif [[ $2 =~ [Nn]ode ]]; then
case ${FUNCTION} in
    start)
        start_node_manager ${DOMAIN} 
        sleep 4
        status_node_manager
        #echo "Node manager PID is `ps -ef | grep "weblogic.NodeManager" | grep -w ${DOMAIN} | awk '{print $2}'` "
        ;;
    stop)
        stop_node_manager ${DOMAIN} 
        status_node_manager
       echo "Stopped Node Manager for ${DOMAIN}" 
        ;;
    status)
       status_node_manager ${DOMAIN} 
        #ps -ef | grep "weblogic.NodeManager" | grep -w ${DOMAIN} 
        ;;
    *)
        echo "Invalid function: " ${FUNCTION}
        ;;
esac
fi
