#/bin/bash

function usage {
	echo "p/make [--print] [--local] model"
	exit 2
}

PP=$(dirname $0)
test -f $PP/conf.ini || $PP/config
test -f $PP/conf.ini || exit -1
. $PP/lib.bash
source_conf

ENGINE="$ENGINE_MAKE"
ONLY_PRINT=false
while ! test -z "$1"
do
	case "$1" in
		-h|--help) usage;;
		--slurm) ENGINE="slurm" ;;
		--pbs) ENGINE="pbs" ;;
		--local) ENGINE="local" ;;
		--print) ONLY_PRINT=true;;
		*) break;
	esac
	shift
done

test -z "$1" && usage

source_engine $ENGINE
BATCH=true
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
) | q_batch | q_wait
