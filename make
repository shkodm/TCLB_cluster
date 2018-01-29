#/bin/bash

PP=$(dirname $0)
[ -f $PP/conf.ini ] || $PP/config
[ -f $PP/conf.ini ] || exit -1
. $PP/conf.ini

PPN=$[$CORES_PER_UNIT_FULL*$MAX_UNITS_PER_NODE]
echo "Running make on $PPN cores"
salloc -A $GRANT -p $DEBUGQ --ntasks=1 --cpus-per-task=$PPN $PP/exec.make -j$PPN $@
