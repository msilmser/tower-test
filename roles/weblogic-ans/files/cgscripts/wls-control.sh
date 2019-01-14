#!/bin/ksh

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
MGD_SERVER=${2:?"Parameter 2 required: managed server"}
FUNCTION=${3:?"Parameter 3 required: start|stop|status|bounce"}

. /users/mwe/cgscripts/server_control_functions.sh
cd /users/domains
if [ ! -d ${DOMAIN} ] ; then
    ls -ld ${DOMAIN}
    echo "domain (${DOMAIN}) not found"
    exit 2
fi

# check_and_start_all_nm

case ${FUNCTION} in
    start)
        start_mgd_server ${DOMAIN} ${MGD_SERVER}
        ;;
    stop)
        stop_mgd_server  ${DOMAIN} ${MGD_SERVER}
        ;;
    status)
        status_mgd_server  ${DOMAIN} ${MGD_SERVER}
        ;;
    bounce)
        bounce_mgd_server  ${DOMAIN} ${MGD_SERVER}
        ;;
    *)
        echo "Invalid function: " ${FUNCTION}
        ;;
esac

