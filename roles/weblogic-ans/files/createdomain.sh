#!/bin/bash

set -x; 

export PATH=".:/users/mwe/jdk8:$PATH"
export WLS_COMMON=/users/mwe/weblogic12.2.1.3/oracle_common/common/bin
export WLST_SCRIPTS=/users/mwe/tmp/files
export WLST_SCRIPTS_LOGS=/users/mwe/tmp/logs
DOMAIN_HOME=/users/domains
umask 022
cd "${WLST_SCRIPTS}" || exit
"${WLS_COMMON}"/wlst.sh "${WLST_SCRIPTS}"/std_domain_cfg_wls12.py "${WLST_SCRIPTS}"/wls_domain_creation.properties << EOF >> "${WLST_SCRIPTS_LOGS}"/create_weblogic_domain.out 2>> "${WLST_SCRIPTS_LOGS}"/create_weblogic_domain.err
c
c
EOF
set -x
find "${DOMAIN_HOME}"/w* -type f ! -perm -a+r -print -exec chmod a+r {} + >> "${WLST_SCRIPTS_LOGS}"/create_weblogic_domain.out 2>&1;
find "${DOMAIN_HOME}"/w* -type d ! -perm -a+rx -print -exec chmod a+rx {} + >> "${WLST_SCRIPTS_LOGS}"/create_weblogic_domain.out 2>&1;
chmod o-rwx "${DOMAIN_HOME}"/w*/security/* "${DOMAIN_HOME}"/w*/security >> "${WLST_SCRIPTS_LOGS}"/create_weblogic_domain.out 2>&1;
for dir in "${DOMAIN_HOME}"/w*/bin ; do
  cp -vp "${WLST_SCRIPTS}"/setUserOverrides.sh "${dir}" >> "${WLST_SCRIPTS_LOGS}"/create_weblogic_domain.out 2>&1
done

#/bin/sed -e 's/^passWord=.*$/passWord=*********/' -e 's/;Credential:[^\\]*\\\\$/;Credential:*********\\\\/' ${WLST_SCRIPTS}/#{create_domain_props_file} > ${WLST_SCRIPTS}/#{create_domain_props_file}.sanitized
#mv -f ${WLST_SCRIPTS}/#{create_domain_props_file}.sanitized ${WLST_SCRIPTS}/#{create_domain_props_file}