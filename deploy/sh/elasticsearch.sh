#! /usr/bin/env bash


current_path=`cd "$(dirname "$0")"; pwd`
app_path=$current_path/../..
. $current_path/function.sh

pid=$app_path/tmp/pids/elasticsearch.pid

cd $app_path
echo "######### info #############"
echo "pid_file_path $pid"
echo "elasticsearch"
echo "############################"



case "$1" in
  start)
    assert_process_from_pid_file_not_exist $pid
    elasticsearch -d -p $pid
    echo "elasticsearch start .............$(command_status)"
  ;;
  status)
    check_run_status_from_pid_file $pid 'elasticsearch'
  ;;
  stop)
    kill `cat $pid`
    echo "elasticsearch stop .............$(command_status)"
  ;;
  *)
    echo "tip:(start|stop|status)"
    exit 5
  ;;
esac

exit 0
