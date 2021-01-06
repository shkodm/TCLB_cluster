function q_header {
	echo "#!/bin/bash -l"
	BATCH=true
	q_option "-j oe"
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
	test -z "$1" || q_option "-N $(echo "$1" | sed 's|[:/.]|-|g')"
}

function q_units { 
	N="$1" # Nodes
	RPN="$2" # MPI ranks per node
	CPR="$3" # CPUs per rank
	GPR="$4" # GPUs per rank

	q_option "-l ncpus=$[$N * $RPN * $CPR]"
	MPI_OPTS="$MPI_OPTS -np $[$N * $RPN]"
	if test "1" -lt "$CPR"
	then
		MPI_OPTS="$MPI_OPTS --map-by node:PE=$CPR --rank-by core"
	fi
	if test "0" -lt "$GPR"
	then
		q_option "-l ngpus=$[$N * $RPN * $GPR]"
	fi
}

function q_walltime {
	test -z "$1" || q_option "-l walltime=$1"
}

function q_qos {
	test -z "$1" || (echo "QoS not supported for PBS scheduler"; exit 0)
}

function q_grant {
	test -z "$1" || q_option "-P $1"
}

function q_queue {
	test -z "$1" || q_option "-q $1"
}

function q_mem {
	N="$1" # Nodes
	RPN="$2" # MPI ranks per node
	MPR="$3" # mem per rank
	test -z "$3" || q_option "-l mem=$[$N * $RPN * $MPR]GB"
}

function q_batch {
	qsub "$@"
}

function q_run {
	if $ONLY_PRINT
	then
		display_scr "$@"
	else
		if $RUN_WAIT
		then
			qsub -W block=true "$@"
		else
			qsub "$@"
		fi
	fi
}

