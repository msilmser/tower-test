#!/bin/sh
# start tc Server based on the standard directory
# Usage: server-control.sh appl [server1 | server2 | ... | ALL ] [start | status | stop]
#
# History
# =======
# 10-27-09	btt	Created from the Covalent
# 08-26-10	btt	Added application from command line
# 08-14-12      btt     Modification for combo - Apache & Tomcat
#######################################################################

if [ $# -lt 1 ]; then
   echo "Usage: $0 appl [server1 | server2 | ... | ALL] [start | status | stop]" && exit 22
fi

if [ `whoami` != "webapp" ]; then
   echo "$0 - Must be webapp to run this script ..."
   exit 1
fi

APSERVER_ROOT=/users/domains/apache/$1
SERVER_DIR="$APSERVER_ROOT"
RC=0

if [ "$2" = "ALL" ]; then
   cd $SERVER_DIR
   SERVER=`/bin/ls -A -1`
else
   SERVER="$2"
fi

for i in $SERVER
do
  if [ -d $APSERVER_ROOT/$i/bin ]; then
      LOG_DIR=$APSERVER_ROOT/$i/logs
      CONF_DIR=$APSERVER_ROOT/$i/conf
      cd $APSERVER_ROOT/$i/bin
 
       if [ "$3" = "start" ]; then
            /users/mwe/cgscripts/ap/rotate.sh 10 $LOG_DIR access_log
	    /users/mwe/cgscripts/ap/rotate.sh 10 $LOG_DIR error_log
            /users/mwe/cgscripts/ap/rotate.sh 10 $LOG_DIR https_access.log
	    /users/mwe/cgscripts/ap/rotate.sh 10 $LOG_DIR https_error.log
	    /users/mwe/cgscripts/ap/rotate.sh 10 $LOG_DIR https_cipher.log


        echo
         if [ -f cg_apache_startup.sh ]; then
            echo "[$1][$i] -----------------------------"
            ./cg_apache_startup.sh $3
            RC=$(($RC + $?))
          elif [ -f apache_startup.sh ]; then
               echo "[$1][$i] -----------------------------"
		./apache_startup.sh $3
           else
	     echo "There is no Apache Server configured for \"$i\""
           fi
	elif [ "$3" = "status" ]; then
               ./apache_startup.sh status	
	elif [ "$3" = "stop" ]; then
               ./apache_startup.sh stop
	 fi
                RC=$(($RC + $?))
   else
      echo "ERROR: Apache Server \"$i\" does not exist"
      RC=$(($RC + 10))
   fi
done
echo  
exit $RC
