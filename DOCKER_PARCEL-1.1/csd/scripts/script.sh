#!/bin/bash
CMD=$1

case $CMD in
  (start)

    service cgconfig start

    if [ ! -z $DOCKER_REGISTRY  ]; then
      ADDITIONAL_ARGUMENTS="$ADDITIONAL_ARGUMENTS --insecure-registry=$DOCKER_REGISTRY"
    fi

    if [ -z "$DOCKER_CONF_GRAPH" ]; then
        exec $DOCKER_HOME/bin/docker -d $ADDITIONAL_ARGUMENTS
    else
        exec $DOCKER_HOME/bin/docker -d $ADDITIONAL_ARGUMENTS -g $DOCKER_CONF_GRAPH
    fi

    ;;
  (stop)
    exec kill -9 `ps aux | grep [d]ocker | awk '{print $2}'`
    ;;
esac