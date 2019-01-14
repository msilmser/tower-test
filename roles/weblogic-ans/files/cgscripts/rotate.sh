#!/bin/ksh +x
###############################################################################
#	rotate.sh    rotate script for log files
#
#  	Input Parameters:
#	1- number of older versions to keep
#	2- directory for the logs
#	3- log file name (with no path)
#
#	Usage:
#		rotate.sh <# of versions to keep> <log directory> <log file name>
#
#	Modification History:
#------------------------------------------------------------------------------
#	04/19/2000	vsl	Created
#	12/30/2005	vsl	Compress older logs with gzip
###############################################################################

###############################################################################
# Three parameters are required to run this script
###############################################################################
if [[ $# < 3 ]]; then
	echo "*** Invalid # of parameters ***"
	echo "Usage:  $0 <# of versions to keep> <log directory> <log file name>"
	exit -1
fi

###############################################################################
# Get the parameters
###############################################################################
COUNT=$1		# number of log file
DIR=$2			# directory of the log files
FILE_NAME=$3		# save log file name

let TMP=$COUNT-1
cd $DIR

###############################################################################
# If the "current" log file does not exist, don't rotate anything.  This usually
# occurs when the daemon/server fails to start, while the logs are already rotated.
# This is done so we do not lose all the log files with several unsuccessful
# "start" attempts.
###############################################################################
if [[ ! -a "$FILE_NAME" ]]; then
	exit 0
fi

###############################################################################
# Compress older log files with gzip, if not already done
###############################################################################
for j in `/bin/ls -A |  grep "$FILE_NAME\..$"`
do
    gzip $j
done

###############################################################################
# rotate each archived version (mv, instead of cp, to preserve modification date)
###############################################################################
while (( $TMP > 0 )); do 
	if [[ -a ${FILE_NAME}.$TMP.gz ]]; then
		mv -f ${FILE_NAME}.$TMP.gz ${FILE_NAME}.$COUNT.gz
	fi

	let COUNT=$COUNT-1
	let TMP=$TMP-1
done

###############################################################################
# Archive the current log file (Usually when a "filesystem full" condition is
# encountered, it's due to the current log file being too large.  Compressing
# the current log file buys time so the server can be restarted immediately
# while any corrective action, such as enlarging the filesystem, can be performed
# at a later and more convenient time).
###############################################################################
mv -f $FILE_NAME ${FILE_NAME}.1
gzip ${FILE_NAME}.1

exit $?
