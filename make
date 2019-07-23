#/bin/bash

PP=$(dirname $0)
[ -f $PP/conf.ini ] || $PP/config
[ -f $PP/conf.ini ] || exit -1
. $PP/lib.bash
. $PP/conf.ini

PPN=$[$CORES_PER_UNIT_FULL*$MAX_UNITS_PER_NODE_DEF_FOR_COMPILATION]

echo "Running make on $PPN cores"

salloc $(arg -A $GRANT) $(arg -p $DEBUGQ) --ntasks=1 --cpus-per-task=$PPN $PP/exec.make -j$PPN $@
