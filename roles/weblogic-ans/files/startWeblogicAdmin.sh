#!/bin/ksh
# Start Weblogic Admin server.  Intended only for use in domain setup process.
# Requires domain name, user, and password parameters.
#
# 2010-11-03  MWO  Created script.

export WLST_SCRIPTS_LOGS=/users/mwe/tmp/logs
DOMAIN="$1"
WLS_USER="$2";export WLS_USER
WLS_PW="$3";export WLS_PW

# Launch Weblogic start script, which takes user and password from WLS_USER and WLS_PW ...
nohup /users/domains/${DOMAIN}/bin/startWebLogic.sh < /dev/null >> ${WLST_SCRIPTS_LOGS}/nohup.out.${DOMAIN} 2>&1 &

# Follow Weblogic standard out file.  Exit when we see message that server started:
#tail -F ./nohup.out.${DOMAIN}|/bin/awk -- 'BEGIN{FS=">"};{print $0};$4 ~ "BEA-000360" {exit}'

echo
