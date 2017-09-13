#/bin/bash

PP=$(dirname $0)
[ -f $PP/conf.ini ] || $PP/config
[ -f $PP/conf.ini ] || exit -1
. $PP/conf.ini

salloc -p debugq --ntasks=1 --cpus-per-task=24 $PP/exec.make -j24 $@
