#!/bin/bash
set -x
CMD=$1

#VARIABLES
HOST_IP=(`hostname -I`)

case $CMD in
  (start-master)

    exec $MESOS_HOME/bin/mesos/sbin/mesos-master --ip=$HOST_IP --quorum=$MESOS_QUORUM_NR --zk=zk://$ZK_QUORUM/mesos --work_dir=$MESOS_HOME/bin/work_dir/mesos --webui_dir=$MESOS_HOME/bin/mesos/share/mesos/webui/ --log_dir=$MESOS_HOME/bin/mesos/log --logging_level=ERROR --port=$MESOS_MASTER_PORT_NR
    ;;
  (start-slave)
    exec $MESOS_HOME/bin/mesos/sbin/mesos-slave --master=zk://$ZK_QUORUM/mesos --ip=$HOST_IP --launcher_dir=$MESOS_HOME/bin/mesos/libexec/mesos --log_dir=$MESOS_HOME/bin/mesos/log/ --logging_level=ERROR --port=$MESOS_SLAVE_PORT_NR --containerizers=docker,mesos --executor_registration_timeout=5mins --docker=$PARCELS_ROOT/DOCKER/bin/docker
    ;;
  (start-marathon)
    exec $MESOS_HOME/bin/marathon/bin/start --master zk://$ZK_QUORUM/mesos --zk zk://$ZK_QUORUM/marathon --http_port $CM_MARATHON_PORT_NR
    ;;
  (start-chronos)
    exec $MESOS_HOME/bin/chronos/bin/start-chronos.bash --master zk://$ZK_QUORUM/mesos --zk_hosts zk://$ZK_QUORUM/mesos --user mesos --http_port $CHRONOS_PORT_NR
    ;;
  (stop-master)
    exec kill -9 `ps aux | grep [m]esos-master | awk '{print $2}'`
    ;;
  (stop-slave)
    exec kill -9 `ps aux | grep [m]esos-slave | awk '{print $2}'`
    ;;
  (stop-marathon)
    exec kill -9 `ps aux | grep [m]arathon | awk '{print $2}'`
    ;;
  (stop-chronos)
    exec kill -9 `ps aux | grep [c]hronos | awk '{print $2}'`
    ;;
  (stop)
    exec kill -9 `ps aux | grep [m]esos-master | awk '{print $2}'`
    exec kill -9 `ps aux | grep [m]esos-slave | awk '{print $2}'`
    exec kill -9 `ps aux | grep [m]arathon | awk '{print $2}'`
    exec kill -9 `ps aux | grep [c]hronos | awk '{print $2}'`
  ;;
  (*)
    echo "Don't understand [$CMD]"
    ;;
esac
