#!/bin/sh
# appstop.sh	Stop wrapper for tc Server
#
# History
# =======
# 08-26-10      btt     Created
# 04-14-11      btt     Modification for multiple apps
#                       There is no need to custom for each app.
# 08-14-12      btt     Modification for combo - Apache & Tomcat
#######################################################################

if [ `whoami` != "webapp" ]; then
   echo "Command ($0) may only be executed by webapp"
   exit 1
fi

/users/mwe/cgscripts/ap/server-control-all.sh stop
