#!/bin/bash

PP=$(dirname $0)
source $PP/conf.ini
# mod_add=true
# source $PP/mods.ini MAKE
# cd $TCLB



if test "$RUN_SINGULARITY" == "y"
then
    echo "running make within singularity"
    srun $SINGULARITY_COMMAND make $@
else
    echo "running make without singularity"
    # $RUN_COMMAND make $@

srun /bin/bash -l << EOF
    echo "###### Nodes:          #######"
        hostname
    echo "###### Loading modules #######"
        source $PP/conf.ini
        mod_add=false
        source $PP/mods.ini CONFIGURE
    echo "###### --------------- #######"
        echo -e "Executing command:\n make $@"
    echo "###### --------------- #######"	
    echo ""
        set -e
        say Started
        cd $TCLB
        make $@
        say Finished
EOF
fi