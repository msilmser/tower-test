#!/bin/ksh
########################################################
# This script will deploy an application to a specified
# target.
#
#########################################################

if [ `whoami` != "webapp" ] ; then
   echo "Command ($0) may only be executed by webapp"
   exit 1
fi

DOMAIN=${1:?"Parameter 1 required: domain"}
APP_NAME=${2:?"Parameter 2 required: application name"}

#DOMAIN=`cd /users/domains/;ls -ld w* |  grep "^d" | awk -F" " '{print $9}'`


if [ ! -d /users/domains/${DOMAIN}/stage ];then

mkdir /users/domains/${DOMAIN}/stage
fi


/users/mwe/cgscripts/deploy.new/runpy.app /users/domains/${DOMAIN}/stage/${APP_NAME}.py
