MESOS_DIRNAME=${PARCEL_DIRNAME}
export MESOS_HOME=$PARCELS_ROOT/$MESOS_DIRNAME
export MESOS_NATIVE_LIBRARY=$MESOS_HOME/bin/mesos/lib/libmesos.so
export MESOS_NATIVE_JAVA_LIBRARY=$MESOS_HOME/bin/mesos/lib/libmesos.so
export LD_LIBRARY_PATH=$MESOS_HOME/bin/mesos/lib/
export PARCELS_ROOT