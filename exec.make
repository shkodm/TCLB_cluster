#!/bin/bash

PP=$(dirname $0)
source $PP/conf.ini
mod_add=true
source $PP/mods.ini MAKE
cd $TCLB


$RUN_COMMAND make $@
