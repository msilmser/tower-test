#!/bin/sh
#

function check_pid_status {
    # set -x
    typeset server_dir="$1"
    typeset service_name="$2"
    typeset apache_pid="$server_dir/logs/httpd.pid"
    typeset -i running
    if [[ -f "$apache_pid" ]] ; then
        typeset pid=`cat "$apache_pid"`
        if [[ -n "$pid" ]] ; then
            ps -fp $pid >/dev/null 2>/dev/null
            running=$?
        else
            running=2
        fi
    else
        running=3
    fi
    if [[ -n "$service_name" ]] ; then
        case "$running" in
            0)
                echo "$service_name (pid $pid) RUNNING"
                ;;
            2)
                echo "$service_name (empty pid file) NOT RUNNING"
                ;;
            3)
                echo "$service_name (no pid file) NOT RUNNING"
                ;;
            *)
                echo "$service_name (pid ${pid}?) NOT RUNNING"
                ;;
        esac
    fi
    # set +x
    return $running
}

function start_server {
    # set -x
    typeset server_dir="$1"
    typeset service_name="$2"
    shift; shift
    typeset flags="$@"

    echo "Starting $service_name"
    check_pid_status $server_dir "$service_name"
    typeset -i pid_status=$?
    if [[ $pid_status -eq 0 ]] ; then
        echo "Server start FAILED (already running)"
        return 1
    fi
    # set -x
    apache_cmd=`echo "$APACHE_BIN -f $server_dir/conf/httpd.conf -d $server_dir $flags" -k start`

    ulimit -n `ulimit -H -n`
    eval $apache_cmd
    typeset -i RETVAL=$?
    if [[ "$RETVAL" -ne 0 ]] ; then
        echo "Server start FAILED - apache httpd return code: $RETVAL"
        return $RETVAL
    fi

    for i in 1 2 3 4 5 6 7 8 9 10; do
        sleep 2
        check_pid_status $server_dir "$service_name"
        if [[ "$RETVAL" -eq 0 ]] ; then
            pid=`cat $server_dir/logs/httpd.pid`
            childlist=`ps -g $pid | grep "httpd"`
            if [[ -n "$childlist" ]] ; then
                echo "Server started OK"
               # set +x
                return 0
            else
                echo "Waiting for httpd child processes to start"
            fi
        fi
    done

    echo "Server start FAILED - pid status check failed"
    # set +x
    return 1
}

function signal_server {
    # set -x
    typeset server_dir="$1"
    typeset service_name="$2"
    typeset action="$3"

    case "$action" in
        "restart" | "graceful" | "stop" | "graceful-stop")
            ;;
        "start")
            echo "Server cannot be started using this function"
            return 2
            ;;
        *)
            echo "signal_server function called with invalid action: \"$action\""
            return 2
            ;;
    esac

    echo "$service_name - Attempting action: $action"
    check_pid_status $server_dir
    typeset -i pid_status=$?
    if [[ $pid_status -gt 0 ]] ; then
        echo "Server not running - action not attempted"
        return 1
    fi

    apache_cmd=`echo "$APACHE_BIN -d $server_dir -k $action"`
    eval $apache_cmd
    typeset -i RETVAL=$?
    if [[ "$RETVAL" -eq 0 ]] ; then
        echo "$service_name - Completed action: $action"
    else
        echo "$service_name - FAILED - action: $action - return code: $RETVAL"
    fi
    # set +x
    return $RETVAL
}
