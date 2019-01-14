#!/bin/sh
# appstatus.sh	Status wrapper for tc Server
#
# History
# =======
# 04-14-11      btt     Created from appstart.sh
# 08-14-12      btt     Modification for combo - Apache & Tomcat
#######################################################################

if [ `whoami` != "webapp" ]; then
   echo "Command ($0) may only be executed by webapp"
   exit 1
fi

/users/mwe/cgscripts/ap/server-control-all.sh status

