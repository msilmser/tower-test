#!/bin/ksh
#Script to back up the WLS domain with configurations -REJJ

if [ `whoami` != "webapp" ] ; then
    echo "Command ($0) may only be executed by webapp"
    exit 1
fi

DOMAIN=${1:?"Parameter 1 required: domain"}

if [ ! -d "/users/domains/${DOMAIN}" ] ; then
    ls -ld "/users/domains/${DOMAIN}"
    echo "domain (${DOMAIN}) not found"
    exit 2
fi


WLS_COMMON=/users/mwe/weblogic12.2.1.3/wlserver/common/bin
DIR=`date '+%m-%d-%Y'`
DATE=`date '+%m-%d-%Y-%H-%M'`

if [[ -d /users/domains/wls_backup/${DOMAIN}/$DIR ]] ; then
   echo $DIR" directory already exist ..."
else
   mkdir -p /users/domains/wls_backup/${DOMAIN}/$DIR 
fi

$WLS_COMMON/pack.sh -domain=/users/domains/${DOMAIN} -template=/users/domains/wls_backup/${DOMAIN}/$DIR/${DOMAIN}.$DATE.jar -template_name="${DOMAIN}"

$WLS_COMMON/pack.sh -managed=true -domain=/users/domains/${DOMAIN} -template=/users/domains/wls_backup/${DOMAIN}/$DIR/${DOMAIN}_mgd.$DATE.jar -template_name="${DOMAIN}_mgd"

cp -rp /users/domains/${DOMAIN}/servers/${DOMAIN}_adm/data/ldap/ldapfiles /users/domains/wls_backup/${DOMAIN}/$DIR/ldapfiles.$DATE
