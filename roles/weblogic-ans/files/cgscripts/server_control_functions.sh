#!/bin/ksh
WLS_COMMON=/users/mwe/weblogic12.2.1.3/wlserver/common/bin
WLST_SCRIPTS=/users/mwe/cgscripts/py

function start_admin_server {
  typeset _domain=$1
  cd /users/domains/${_domain}/bin || exit 1 
  ls -l ./startWebLogic.sh >/dev/null || exit 2
  nohup ./startWebLogic.sh 2>&1 &
}

function stop_admin_server {
  typeset _domain=$1
  cd /users/domains/${_domain}/bin || exit 1
  ls -l ./stopWebLogic.sh >/dev/null || exit 2
  nohup ./stopWebLogic.sh >>nohup.out 2>&1 &
}

function stop_node_manager {
  typeset _domain=$1
  cd /users/domains/${_domain}/bin || exit 1
  ls -l ./stopNodeManager.sh >/dev/null || exit 2
  nohup ./stopNodeManager.sh >>nohup.out 2>&1 &
}

function start_node_manager {
  typeset _domain=$1
  cd /users/domains/${_domain}/bin || exit 1
  ls -l ./startNodeManager.sh >/dev/null || exit 2
  nohup ./startNodeManager.sh >>nohup.out 2>&1 &
}

function start_mgd_server {
  _raw_start_mgd_server "$@" 2>&1 | sed -n -e '/Connecting to t3/,$p'
}

function stop_mgd_server {
  _raw_stop_mgd_server "$@"  2>&1 | sed -n -e '/Connecting to t3/,$p'
}

function _raw_start_mgd_server {
  typeset _domain=$1
  typeset _server=$2
  shift 1
  cd /users/domains/${_domain}
  pwd
  echo "$@"
  #pgrep -f -u webapp ${_server} >/dev/null 2>/dev/null
  pgrep -f -u webapp -x "Name=${MGD_SERVER}" | grep -v grep
  svr_status=$?
  if [[ $svr_status -gt 0 ]] ; then
    $WLS_COMMON/wlst.sh $WLST_SCRIPTS/control_managed_servers.py "start" "${_domain}" "$@"
  else
    echo server ${_server} is already started 
  fi
}

function _raw_stop_mgd_server {
  typeset _domain=$1
  typeset _server=$2
  shift 1
  cd /users/domains/${_domain}
  pwd
  echo "$@"
  pgrep -f -u webapp ${_server} >/dev/null 2>/dev/null
  svr_status=$?
  if [[ $svr_status -eq 0 ]] ; then
    $WLS_COMMON/wlst.sh $WLST_SCRIPTS/control_managed_servers.py "stop" "${_domain}" "$@"
  else
    echo server ${_server} is already stoped
  fi
}

function bounce_mgd_server {
  typeset _domain=$1
  shift 1
  cd /users/domains/${_domain}
  $WLS_COMMON/wlst.sh $WLST_SCRIPTS/control_managed_servers.py "bounce" "${_domain}" "$@"
}

function status_mgd_server {
  MGD_SERVER=${2:?"Parameter 2 required: managed server"}
  pid=`pgrep -f -u webapp "Name=${MGD_SERVER}" | grep -v grep`
  if [ -n "$pid" ] ; then
      echo "WebLogic ${MGD_SERVER} is running and it's PID(s) is ${pid} !"
  else
      echo "ERROR: ${MGD_SERVER} is NOT running!"
  fi
}

function status_admin_server {
  ADM_SERVER=${2:?"Parameter 2 required: Node or Admin "}
  pid=`pgrep -f -u webapp "Name=${ADM_SERVER}" | grep -v grep`
  if [ -n "$pid" ] ; then
        echo "WebLogic ${ADM_SERVER} is running and it's PID(s) is ${pid} !"
  else
        echo "ERROR: ${ADM_SERVER} is NOT running!"
  fi
}

function status_node_manager {
  pid=`ps -ef | grep "weblogic.NodeManager" | grep -w ${DOMAIN} | awk '{print $2}'`
  if [ -n "$pid" ] ; then
        echo "WebLogic ${NODE_MGR} is running and it's PID(s) is ${pid} !"
  else
        echo "ERROR: ${NODE_MGR} is NOT running!"
  fi
}
