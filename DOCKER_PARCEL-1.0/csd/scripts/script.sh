#!/bin/bash
CMD=$1

case $CMD in
  (start)

    service cgconfig start

    if [ ! -z $DOCKER_REGISTRY  ]; then
      ADDITIONAL_ARGUMENTS="$ADDITIONAL_ARGUMENTS --insecure-registry=$DOCKER_REGISTRY"
    fi

    exec $DOCKER_HOME/bin/docker -d $ADDITIONAL_ARGUMENTS
    ;;
  (stop)
    exec kill -9 `ps aux | grep [d]ocker | awk '{print $2}'`
    ;;
esac