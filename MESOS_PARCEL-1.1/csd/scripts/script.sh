#!/bin/bash
set -x
CMD=$1

#VARIABLES
HOST_IP=(`hostname -I`)


case $CMD in
  (start-master)

    exec $MESOS_HOME/opt/mesos/sbin/mesos-master --ip=$HOST_IP --quorum=$MESOS_QUORUM_NR --zk=zk://$ZK_QUORUM/mesos \
     --work_dir=$MESOS_HOME/opt/work_dir/mesos --webui_dir=$MESOS_HOME/opt/mesos/share/mesos/webui/ \
     --log_dir=$MESOS_HOME/opt/mesos/log --logging_level=ERROR --port=$MESOS_MASTER_PORT_NR
    ;;
  (start-slave)

     exec $MESOS_HOME/opt/mesos/sbin/mesos-slave --master=zk://$ZK_QUORUM/mesos --ip=$HOST_IP \
    --launcher_dir=$MESOS_HOME/opt/mesos/libexec/mesos --log_dir=$MESOS_HOME/opt/mesos/log/ \
    --logging_level=ERROR --port=$MESOS_SLAVE_PORT_NR --containerizers=docker,mesos \
    --executor_registration_timeout=5mins --docker=$PARCELS_ROOT/DOCKER/bin/docker

    ;;
  (start-marathon)
    JAVA_HOME=$JAVA_HOME exec $MESOS_HOME/opt/marathon/bin/start --master zk://$ZK_QUORUM/mesos --zk zk://$ZK_QUORUM/marathon --http_port $CM_MARATHON_PORT_NR
    ;;
  (start-mesos-dns)
  #configure mesos dns
    cp $MESOS_HOME/opt/mesos-dns/template-mesos-dns-config.json $MESOS_HOME/opt/mesos-dns/mesos-dns-config.json
    #sed-up the config file
    echo "copied template "

        sed -i s^####zookeeper####^$ZK_QUORUM^ $MESOS_HOME/opt/mesos-dns/mesos-dns-config.json

        JSON_MESOS_CONFIG=`cat $MESOS_HOME/opt/mesos-dns/mesos-dns-config.json`
        JSON_MESOS_DNS_MASTERS="${JSON_MESOS_CONFIG//####masters####/$MESOSDNS_CONF_MASTERS}"
        echo -e "$JSON_MESOS_DNS_MASTERS" > $MESOS_HOME/opt/mesos-dns/mesos-dns-config.json

        MESOSDNS_CONF_SOARNAME="$MESOSDNS_CONF_NS.$MESOSDNS_CONF_DOMAIN"
        MESOSDNS_CONF_SOAMNAME="$MESOSDNS_CONF_SOAMNAME.$MESOSDNS_CONF_SOARNAME"

        sed -i s^####refreshSeconds####^$MESOSDNS_CONF_REFRESHSECONDS^ $MESOS_HOME/opt/mesos-dns/mesos-dns-config.json
        sed -i s^####ttl####^$MESOSDNS_CONF_TTL^ $MESOS_HOME/opt/mesos-dns/mesos-dns-config.json
        sed -i s^####domain####^$MESOSDNS_CONF_DOMAIN^ $MESOS_HOME/opt/mesos-dns/mesos-dns-config.json
        sed -i s^####ns####^$MESOSDNS_CONF_NS^ $MESOS_HOME/opt/mesos-dns/mesos-dns-config.json
        sed -i s^####port####^$MESOSDNS_CONF_PORT^ $MESOS_HOME/opt/mesos-dns/mesos-dns-config.json
        sed -i s^####resolvers####^$MESOSDNS_CONF_RESOLVERS^ $MESOS_HOME/opt/mesos-dns/mesos-dns-config.json
        sed -i s^####timeout####^$MESOSDNS_CONF_TIMEOUT^ $MESOS_HOME/opt/mesos-dns/mesos-dns-config.json
        sed -i s^####listener####^$MESOSDNS_CONF_LISTENER^ $MESOS_HOME/opt/mesos-dns/mesos-dns-config.json
        sed -i s^####SOAMname####^$MESOSDNS_CONF_SOAMNAME^ $MESOS_HOME/opt/mesos-dns/mesos-dns-config.json
        sed -i s^####SOARname####^$MESOSDNS_CONF_SOARNAME^ $MESOS_HOME/opt/mesos-dns/mesos-dns-config.json
        sed -i s^####SOARefresh####^$MESOSDNS_CONF_SOAREFRESH^ $MESOS_HOME/opt/mesos-dns/mesos-dns-config.json
        sed -i s^####SOARetry####^$MESOSDNS_CONF_SOARETRY^ $MESOS_HOME/opt/mesos-dns/mesos-dns-config.json
        sed -i s^####SOAExpire####^$MESOSDNS_CONF_SOAEXPIRE^ $MESOS_HOME/opt/mesos-dns/mesos-dns-config.json
        sed -i s^####SOAMinttl####^$MESOSDNS_CONF_SOAMINTTL^ $MESOS_HOME/opt/mesos-dns/mesos-dns-config.json
        sed -i s^####dnson####^$MESOSDNS_CONF_DNSON^ $MESOS_HOME/opt/mesos-dns/mesos-dns-config.json
        sed -i s^####httpon####^$MESOSDNS_CONF_HTTPON^ $MESOS_HOME/opt/mesos-dns/mesos-dns-config.json
        sed -i s^####httpport####^$MESOSDNS_CONF_HTTPPORT^ $MESOS_HOME/opt/mesos-dns/mesos-dns-config.json
        sed -i s^####externalon####^$MESOSDNS_CONF_EXTERNALON^ $MESOS_HOME/opt/mesos-dns/mesos-dns-config.json
        sed -i s^####recurseon####^$MESOSDNS_CONF_RECURSEON^ $MESOS_HOME/opt/mesos-dns/mesos-dns-config.json

    exec $MESOS_HOME/opt/mesos-dns/mesos-dns -config=$MESOS_HOME/opt/mesos-dns/mesos-dns-config.json

  (stop-master)
    exec kill -9 `ps aux | grep [m]esos-master | awk '{print $2}'`
    ;;
  (stop-slave)
    exec kill -9 `ps aux | grep [m]esos-slave | awk '{print $2}'`
    ;;
  (stop-marathon)
    exec kill -9 `ps aux | grep [m]arathon | awk '{print $2}'`
    ;;
  (stop)
     kill -9 `ps aux | grep [m]esos-master | awk '{print $2}'`
     kill -9 `ps aux | grep [m]esos-slave | awk '{print $2}'`
     exec kill -9 `ps aux | grep [m]arathon | awk '{print $2}'`
  ;;
  (*)
    echo "Don't understand [$CMD]"
    ;;
esac
