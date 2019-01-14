#!/bin/ksh
#######################################################################
NM_SEARCHSTRING="weblogic12\.2\.1\.3.*weblogic\.NodeManager"
WL_SEARCHSTRING="Dweblogic\.Name=.*weblogic12\.2\.1\.3"

if [ `whoami` != "webapp" ] ; then
   echo "Command ($0) may only be executed by webapp"
   exit 1
fi

#cd /users/domains

NM_SEARCHRESULT=`pgrep -u webapp -f $NM_SEARCHSTRING`

if [ -n "$NM_SEARCHRESULT" ] ; then
	echo "Killing nm processes: <$NM_SEARCHRESULT>"
	pkill -u webapp -f $NM_SEARCHSTRING &
	sleep 5
else
   echo "No nodemanager processes found."
fi

# kill off any weblogic processes that were not shutdown earlier from xappstop.sh.
WL_SEARCHRESULT=`pgrep -u webapp -f $WL_SEARCHSTRING`

if [ -n "$WL_SEARCHRESULT" ] ; then
	echo "Killing weblogic processes: <$WL_SEARCHRESULT>"
	pkill -u webapp -f $WL_SEARCHSTRING &
	sleep 10
else
   echo "No weblogic processes found."
fi

NM_SEARCHRESULT=`pgrep -u webapp -f $NM_SEARCHSTRING`
WL_SEARCHRESULT=`pgrep -u webapp -f $WL_SEARCHSTRING`

if [ -z "$NM_SEARCHRESULT" -a -z "$WL_SEARCHRESULT" ] ; then
   echo "No remaining nodemanager or weblogic processes found. Exiting 0."
   exit 0 
fi

echo "Remaining nodemanager or weblogic processes found. Exiting 1."
exit 1 
