#!/bin/bash

PP=$(dirname $0)
source $PP/conf.ini
mod_add=true
source $PP/mods.ini MAKE
cd $TCLB


if hostname | grep "rysy\.icm\.edu\.pl" >/dev/null
then
    srun $RUN_COMMAND make $@
else
    $RUN_COMMAND make $@
fi