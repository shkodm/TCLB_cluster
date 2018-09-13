#!/bin/bash

PP=$(dirname $0)
source $PP/conf.ini
mod_add=true
source $PP/mods.ini MAKE
cd $TCLB

for m in $@
do
	$RUN_COMMAND make -j$SLURM_CPUS_PER_TASK $m
done
