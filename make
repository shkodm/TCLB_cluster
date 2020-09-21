#/bin/bash

set -e

function usage {
	echo "p/make [--print] [--local] [--no-wait] model"
	exit 2
}

PP=$(dirname $0)
test -f $PP/conf.ini || $PP/config
test -f $PP/conf.ini || exit -1
. $PP/lib.bash
source_conf

ENGINE="$ENGINE_MAKE"
ONLY_PRINT=false
RUN_WAIT=true
for arg
do
	shift
	case "$arg" in
		-h|--help) usage;;
		--slurm) ENGINE="slurm" ;;
		--pbs) ENGINE="pbs" ;;
		--local) ENGINE="local" ;;
		--print) ONLY_PRINT=true;;
		--no-wait) RUN_WAIT=false;;
		*) set -- "$@" "$arg";;
	esac
done

test -z "$1" && usage

source_engine $ENGINE
(
	q_header
	q_name "TCLB:make:$MODEL"
	q_queue $DEBUG_PARTITION
	q_grant $GRANT
	q_qos $DEBUG_QOS
	q_walltime 00:15:00
	q_units 1 1 $MAX_TASKS_PER_NODE_FOR_COMPILATION 0

	echo
	echo "set -e # exit on error"
	echo
	module_list $MODULES_BASE $MODULES_ADD $MODULES_RUN
	echo
	echo "cd $TCLB"
	echo "make -j $MAX_TASKS_PER_NODE_FOR_COMPILATION" "$@"
) >tmp.job.scr

q_run tmp.job.scr
