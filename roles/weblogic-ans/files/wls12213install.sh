#!/bin/bash

set -x; 
TMP_DIR=/users/mwe/tmp
FILES_DIR=${TMP_DIR}/files
JAVA_HOME=/users/mwe/jdk8; export JAVA_HOME
PATH=$JAVA_HOME/bin:$PATH; export PATH
cd ${FILES_DIR}
umask 0002

/users/mwe/jdk8/bin/java -d64 -Xmx1024m -Djava.io.tmpdir=${TMP_DIR} -Djava.security.egd=file:/dev/./urandom -jar ${FILES_DIR}/fmw_12.2.1.3.0_wls.jar -silent -force -printdiskusage -printmemory -invPtrLoc ${FILES_DIR}/oraInst.loc -responseFile ${FILES_DIR}/wls12213instresp.txt 

find /users/mwe/weblogic12.2.1.3 -type d -exec chmod a+rx {} +
find /users/mwe/weblogic12.2.1.3 -name "*.sh" -exec chmod a+rx {} +
find /users/mwe/weblogic12.2.1.3 -type f -exec chmod a+r {} +

GREP_OPTIONS='--binary-files=without-match  --directories=skip'
export GREP_OPTIONS
shopt -s globstar

cd /users/mwe/weblogic12.2.1.3

# backup scripts
for f in `egrep -l -e '^umask 027$' oracle_common/**/bin/*sh wlserver/**/bin/*sh` ; do
    SAVE_FILE=${f}.save.`date +'%Y%m%d.%H%M%S'`
    cp -p ${f} ${SAVE_FILE}
    sed -e '1,$s/umask 027$/umask 022/g' ${SAVE_FILE} > ${f}
done
