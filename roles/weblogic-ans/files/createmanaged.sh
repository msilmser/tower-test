#!/bin/bash

set -x; 

export PATH=".:/users/mwe/jdk8:$PATH"
export WLS_COMMON=/users/mwe/weblogic12.2.1.3/oracle_common/common/bin
export WLST_SCRIPTS=/users/mwe/tmp/files
export WLST_SCRIPTS_LOGS=/users/mwe/tmp/logs
DOMAIN_HOME=/users/domains
umask 022

id > ${WLST_SCRIPTS_LOGS}/create_weblogic_instance.out 2> ${WLST_SCRIPTS_LOGS}/create_weblogic_instance.err
#cd ${DOMAIN_HOME}/w?#{node['hostname']} || exit
cd ${DOMAIN_HOME}/w* || exit

${WLS_COMMON}/wlst.sh ${WLST_SCRIPTS}/std_managed_server_cfg_wls12.py ${WLST_SCRIPTS}/wls_domain_creation.properties << EOF >> ${WLST_SCRIPTS_LOGS}/create_weblogic_instance.out 2>> ${WLST_SCRIPTS_LOGS}/create_weblogic_instance.err
c
EOF