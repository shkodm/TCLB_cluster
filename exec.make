#!/bin/bash

PP=$(dirname $0)
. $PP/mods.ini
. $PP/conf.ini
srun make $@
