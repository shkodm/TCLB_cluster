function q_header {
	echo "#!/bin/bash"
}

function q_option {
	if $BATCH
	then
		echo "#PBS" "$@"
	else
		echo "$@"
	fi
}

function q_name {
	test -z "$1" || q_option "-N $1"
}

function q_units { 
	N="$1" # Nodes
	RPN="$2" # MPI ranks per node
	CPR="$3" # CPUs per rank
	GPR="$4" # GPUs per rank

	nodespec=""
	nodespec="$nodespec:ncpus=$[$CPR * $RPN]"
	if test "1" -lt "$CPR"
	then
		nodespec="$nodespec:ncpus=$[$CPR * $RPN]:mpiprocs=$RPN"
	fi
	if test "0" -lt "$GPR"
	then
		nodespec="$nodespec:gpus=$[$GPR * $RPN]"
	fi
	q_option "-l select=$N$nodespec"
}

function q_walltime {
	test -z "$1" || q_option "-l walltime=$1"
}

function q_qos {
	test -z "$1" || (echo "QoS not supported for PBS scheduler"; exit 0)
}

function q_grant {
	test -z "$1" || q_option "-A $1"
}

function q_queue {
	test -z "$1" || q_option "-q $1"
}

function q_batch {
	qsub "$@"
}

function q_run_and_wait {
	if $ONLY_PRINT
	then
		cat $1 | display_scr
	else
		qsub -W block=true "$@"
	fi
}

