#!/bin/sh

DEPLOY_SCRIPTS_DIR="/users/mwe/cgscripts/deploy.new"

P1=$1
if [[ ! -f ${P1} ]] ; then
  P1="${DEPLOY_SCRIPTS_DIR}/${P1}"
fi

#DOMAIN_HOME="$(pwd)"
# Parse domain home location from the python script:
DOMAIN_HOME=$(/bin/sed  -n -re '/^(deployPath|domainDir) *=/ { s:.*(/users/domains/[[:alnum:]]*).*:\1: ;p;q}' ${P1})

mkdir -p ${DOMAIN_HOME}/stage
cd ${DOMAIN_HOME}/stage


mv -f runpy8.log runpy9.log > /dev/null 2>&1
mv -f runpy7.log runpy8.log > /dev/null 2>&1
mv -f runpy6.log runpy7.log > /dev/null 2>&1
mv -f runpy5.log runpy6.log > /dev/null 2>&1
mv -f runpy4.log runpy5.log > /dev/null 2>&1
mv -f runpy3.log runpy4.log > /dev/null 2>&1
mv -f runpy2.log runpy3.log > /dev/null 2>&1
mv -f runpy1.log runpy2.log > /dev/null 2>&1
mv -f runpy.log runpy1.log  > /dev/null 2>&1

cd ${DOMAIN_HOME}

P2=$2
P3=$3
P4=$4
P5=$5
P6=$6


. ${DOMAIN_HOME}/bin/setDomainEnv.sh


echo "Running Python script... ($P1)($P2)($P3)($P4)($P5)($P6)" | tee stage/runpy.log

${JAVA_HOME}/bin/java -Dpython.path=/users/mwe/cgscripts/deploy.new/module -Dwlst.offline.log=disable weblogic.WLST $P1 $P2 $P3 $P4 $P5 $P6 | tee -a stage/runpy.log

echo "Done" | tee -a stage/runpy.log

exit


  
