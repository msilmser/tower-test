#!/bin/ksh

LOGS_DIR=${1:?"Parameter 1 required: logs directory"}
COMPRESS_DAYS=${2:-7}
DELETE_DAYS=${3:-30}

if [ `whoami` != "webapp" ] ; then
   echo "Command ($0) may only be executed by webapp"
   exit 1
fi

cd ${LOGS_DIR} || exit 1

find *.out0*[0-9].gz -maxdepth 0 -mtime +${DELETE_DAYS} -type f -exec rm -v {} +
find *.out0*[0-9] -maxdepth 0 -mtime +${COMPRESS_DAYS} -type f -exec gzip -v9 {} +
find *.out0*[0-9].gz -maxdepth 0 -mtime +${DELETE_DAYS} -type f -exec rm -v {} +
find access.log0*[0-9].gz -maxdepth 0 -mtime +${DELETE_DAYS} -type f -exec rm -v {} +
find access.log0*[0-9] -maxdepth 0 -mtime +${COMPRESS_DAYS} -type f -exec gzip -v9 {} +
find access.log0*[0-9].gz -maxdepth 0 -mtime +${DELETE_DAYS} -type f -exec rm -v {} +
