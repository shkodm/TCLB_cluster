#/bin/bash

PP=$(dirname $0)
[ -f $PP/conf.ini ] || $PP/config
[ -f $PP/conf.ini ] || exit -1
. $PP/conf.ini

salloc -A $GRANT -p $DEBUGQ --ntasks=1 --cpus-per-task=12 $PP/exec.make -j12 $@
