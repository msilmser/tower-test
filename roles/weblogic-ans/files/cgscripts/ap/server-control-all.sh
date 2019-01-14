#!/bin/sh
# start tc Server based on the standard directory
# Usage: server-control-all.sh [start | status | stop]
#
# History
# =======
# 03-28-11	btt	Created from server-control.sh
# 05-26-11	btt	Modified for Apache
# 08-14-12      btt     Modification for combo - Apache & Tomcat
#######################################################################

if [ $# -lt 1 ]; then
   echo "Usage: $0 [start | status | stop] [ optional time-out value for stop ]" && exit 22
fi

if [ `whoami` != "webapp" ]; then
   echo "$0 - Must be webapp to run this script ..."
   exit 1
fi

APPS_DIR=/users/domains/apache
RC=0

cd $APPS_DIR
APPS=`/bin/ls -A -1`

for i in $APPS
do
   /users/mwe/cgscripts/ap/server-control.sh $i ALL $1 $2   
   RC=$(($RC + 10))
done
echo
exit $RC
