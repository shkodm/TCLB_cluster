#/bin/bash

PP=$(dirname $0)
[ -f $PP/conf.ini ] || $PP/config
[ -f $PP/conf.ini ] || exit -1
. $PP/conf.ini

srun -p plgrid --cpus-per-task=16 -A $GRANT make -j 16 $@
