#!/bin/sh

if [ `whoami` != "mwadmin" ] ; then
        echo "Command ($0) may only be executed by mwadmin"
        exit 1
fi


###################################################################################
# send out email
###################################################################################

cd /users/mwe/cgscripts
test -f ./.cgscripts.profile && . ./.cgscripts.profile

nohup echo -e "`hostname` - server was restarted.\n http://atm/Search/?q=${_CG_APPLICATION_ID} " | /bin/mail \
  -s "`hostname` - Server Was Restarted (${_CG_ZONE}/${_CG_ENVIRONMENT}/${_CG_APPLICATION_ID})" "ME_APP_SERVER_ADMINS@capgroup.com" &

###################################################################################
# server-specific stuff
###################################################################################


