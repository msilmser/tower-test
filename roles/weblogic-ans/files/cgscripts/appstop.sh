#!/bin/ksh
if [ `whoami` != "webapp" ] ; then
   echo "Command ($0) may only be executed by webapp"
   exit 1
fi

# pkill -u webapp

if [ -d "/users/domains/apache" ]; then
   /users/mwe/cgscripts/ap/appstop.sh
fi

. /users/mwe/cgscripts/server_control_functions.sh

#check for custom startup order

if [ -s /users/mwe/cgscripts/py/startup_order.txt ];then
   echo "Customized shutdown order found, using it to shutdown managed servers"

   tac "/users/mwe/cgscripts/py/startup_order.txt" | while read LINE ; do
   domain=`echo "$LINE" | awk '{print $1}'`

   status_admin_server ${domain} ${domain}_adm

   echo "stop_mgd_server $LINE" 
   stop_mgd_server $LINE 
   done

 cd /users/domains

 typeset domains=`ls -xd w*`
 for dm in `echo $domains` ; do

  cd /users/domains/${dm}/bin || continue

  echo "Stopping Admin server for domain ${dm}"
  stop_admin_server ${dm}
  echo "Stopping Node Manager for domain ${dm}"
  stop_node_manager ${dm}
  sleep 7
  cd ../..
  done

   exit
fi

cd /users/domains

typeset domains=`ls -xd w*`
for dm in `echo $domains` ; do

  cd /users/domains/${dm}/servers || continue

  typeset servers=`ls -xd *`
  for svr in `echo $servers` ; do

    if [[ "$svr" != domain_bak && "$svr" != *_adm ]] ; then
         echo ................ $dm $svr .................
         stop_mgd_server $dm $svr
    else
         continue
    fi

  done

  echo "Stopping Admin server for ${dm}"
  stop_admin_server ${dm}
  echo "Stopping Node Manager for ${dm}"
  stop_node_manager ${dm}
  sleep 7
  cd ../..
done

