#!/bin/ksh
# Update Java memory settings in Weblogic Admin start script.
# Intended only for use in domain setup process.
# Requires domain bin directory parameter.
#
# Set MaxPermSize=350m for wls 12

cd ${1:?"Parameter 1 required: domain bin directory"}
if [ $? -gt 0 ] ; then
  echo "domain bin directory invalid or not accessible"
  exit 1
fi

SAVE_FILE=setDomainEnv.sh.save.`date +'%Y%m%d.%H%M%S'`
cp -p setDomainEnv.sh ${SAVE_FILE}
sed -e '1,$s/PermSize=[[:digit:]]*m/PermSize=128m/g' \
    -e '1,$s/MaxPermSize=[[:digit:]]*m/MaxPermSize=350m/g' \
    -e '1,$s/^\([[:space:]]*DERBY_FLAG=\)"true"/\1"false"/g' \
    ${SAVE_FILE} > setDomainEnv.sh

# Option not required for JDK1.7
# -e '1,$s:jdk160_05:jdk1.6.0_24:g' \
# -e '1,$s/Xms[[:digit:]]*m/Xms512m/g' -e '1,$s/Xmx[[:digit:]]*m/Xmx768m/g'

