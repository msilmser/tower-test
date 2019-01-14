#!/bin/sh

# scriptLogFile=/users/mwe/cgscripts/admin_map.log

domain=$1

function getConfig {
   for f in $configFiles
   do
    if [ -s $f ]; then
    echo "#############################################################"
    #echo $f | tee -a $scriptLogFile
    adminHost=`grep -oPm1 '(?<=<listen-address>)[^<]+' $f`
    echo "Admin_host $adminHost"
    domain=`grep -oPm1 '(?<=<name>)[^<]+' $f`
    echo "domain_name $domain"
    adminPort=`grep -oPm2 '(?<=<listen-port>)[^<]+' $f | awk 'NR==2'`
    echo "Admin_port  $adminPort"
    adminPort1=`grep -oPm2 '(?<=<listen-port>)[^<]+' $f | awk 'NR==1'`
    echo "$domain=$adminHost:$adminPort" >>/users/mwe/cgscripts/py/admin_map.txt
    fi
done
}
# If domain name is not passed in as argument then add all domains to map file

if [ -z $domain ]; then
  configFiles=/users/domains/w*/config/config.xml
else
  configFiles=/users/domains/${domain}/config/config.xml
  if [ -f $configFiles ]; then
    echo $configFiles #| tee -a $scriptLogFile
  else
    echo Searching for $configFiles #| tee -a $scriptLogFile
    echo No instance found with this name $domain. Please check name exist. # | tee -a $scriptLogFile
    exit 1
  fi  
fi
getConfig
