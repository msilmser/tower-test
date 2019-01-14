#!/bin/ksh
#set -x

if [ `whoami` != "webapp" ] ; then
   echo "Command ($0) may only be executed by webapp"
   exit 1
fi

. /users/mwe/tmp/files/xserver_control_functions.sh
cd /users/domains

typeset domains=`ls -xd w*`
for dm in `echo $domains` ; do

  cd /users/domains/${dm}/servers || continue

  typeset servers=`ls -xd *`
  for svr in `echo $servers` ; do

    if [[ "$svr" != domain_bak && "$svr" != *_adm ]] ; then
         echo stopping ................ $dm $svr .................
         xstop_mgd_server $dm $svr
         sleep 5
    else
         continue
    fi
  done

  xstop_admin_server ${dm}
  cd ../..
  sleep 15
done

