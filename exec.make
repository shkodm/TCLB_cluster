#!/bin/bash

PP=$(dirname $0)
. $PP/mods.ini
. $PP/conf.ini
cd $TCLB
srun make $@
