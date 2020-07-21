#/bin/bash

PP=$(dirname $0)
[ -f $PP/conf.ini ] || $PP/config
[ -f $PP/conf.ini ] || exit -1
. $PP/lib.bash
. $PP/conf.ini

PPN=$[$CORES_PER_TASK_FULL*$MAX_TASKS_PER_NODE_FOR_COMPILATION]
echo "Running make on $PPN cores"
echo "salloc $(arg --account $GRANT) $(arg --partition $DEBUG_PARTITION) $(arg --qos $MAIN_QOS) --ntasks=1 --cpus-per-task=$PPN $PP/exec.make -j$PPN $@"
salloc $(arg --account $GRANT) $(arg --partition $DEBUG_PARTITION) $(arg --qos $MAIN_QOS) --ntasks=1 --cpus-per-task=$PPN $PP/exec.make -j$PPN $@
