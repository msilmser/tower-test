#!/bin/ksh
if [ `whoami` != "webapp" ] ; then
   echo "Command ($0) may only be executed by webapp"
   exit 1
fi

. /users/mwe/cgscripts/server_control_functions.sh
cd /users/domains

typeset domains=`ls -xd w*`
for dm in `echo $domains` ; do

  cd ${dm}/servers
  typeset servers=`ls -xd *`
  for svr in `echo $servers` ; do

     if [[ $svr != domain_bak ]] ; then
         echo ................ $dm $svr .................
         status_mgd_server $dm $svr
     else
         continue
     fi

  done
  cd ../..
done

