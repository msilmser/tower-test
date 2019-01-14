#!/bin/ksh +x
#
# Check status of servers based on the standard Covalent directory structure
#
# Usage: status.sh [server1 server2....|ALL]
#
#
# History
# =======
#
# 12-22-2005 vsl  created
# 05-26-2011 btt  Modified for the new MWE Apache standard
#
####################################################################
if [ $# -lt 1 ]; then
   echo "Usage: $0 appl [server1 | server2 | ... | ALL]" && exit 22
fi

SERVER_DIR="/users/domains/apache/$1"
RC=0

####################################################################
# Get the list of servers to find status on
####################################################################
if [ "$2" = "ALL" ]; then
   cd $SERVER_DIR
   SERVER=`ls -A -1`
else
   SERVER="$2"
fi

####################################################################
# Process each server in the server list
####################################################################
for i in $SERVER
do
    LOG_DIR=$SERVER_DIR/$i/logs
    CONF_DIR=$SERVER_DIR/$i/conf

    if [[ -d $CONF_DIR && -d $LOG_DIR ]]; then
        cd $LOG_DIR

        ############################################################
	# If apache is configured for this instance, check the 
	# existence of the process against the PID file in the log
	# directory.
	# NOTE: apache erases the PID file when it shuts down
        ############################################################
	if [ -f $CONF_DIR/httpd.conf ]; then
            if [ -f httpd.pid ]; then
                PID=$(cat httpd.pid)
                ps -e | grep $PID > /dev/null
		N=$?
		RC=$(($RC + $N))

	        if [ $N -eq 0 ]; then
	            echo "  Apache($PID):	OK"
                else
	            echo "  Apache:	NOT RUNNING!"
                fi
            else
	        echo "  Apache:	NOT RUNNING or PID file removed abnormally!"
		RC=$(($RC + 1))
            fi
	fi
    else
        echo "---------"
        echo "  ERROR: Server $i does not exist"
	RC=$(($RC + 10))
    fi
    echo " "
done
   
exit $RC
