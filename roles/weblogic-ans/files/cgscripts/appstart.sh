#!/bin/ksh
if [ `whoami` != "webapp" ] ; then
   echo "Command ($0) may only be executed by webapp"
   exit 1
fi

if [ -d "/users/domains/apache" ]; then
   /users/mwe/cgscripts/ap/appstart.sh
fi

for bin_dir in `ls -xd /users/domains/w*/bin` ; do
  cd ${bin_dir} || continue

  echo "Starting Admin ${bin_dir}/startWebLogic.sh"
  nohup ${bin_dir}/startWebLogic.sh &

  echo "Starting Node manager ${bin_dir}/startNodeManager.sh"
  nohup ${bin_dir}/startNodeManager.sh &
  sleep 15

done

. /users/mwe/cgscripts/server_control_functions.sh

#check for custom startup order

if [ -s /users/mwe/cgscripts/py/startup_order.txt ];then
   echo " Customized startup order found, using it to start managed servers"

   cat "/users/mwe/cgscripts/py/startup_order.txt" | while read LINE ; do
   domain=`echo "$LINE" | awk '{print $1}'`

   status_admin_server ${domain} ${domain}_adm

   echo "start_mgd_server $LINE" 
   start_mgd_server $LINE 
   done
   exit
fi


#Get list of domains
cd /users/domains
typeset domains=`ls -xd w*`
for dm in `echo $domains` ; do

  status_admin_server ${dm} ${dm}_adm

  #get list of servers
  echo
  sleep 5
  cd /users/domains
  cd ${dm}/servers || continue
  typeset servers=`ls -xd *`
  for svr in `echo $servers` ; do
  if [[ "$svr" != domain_bak && "$svr" != *_adm ]] ; then
        echo ................ $dm $svr .................
        start_mgd_server $dm $svr
     else
         continue
     fi
  done
  cd ../..

done

