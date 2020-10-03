function q_header {
	true
}

function q_option {
	true
}

function q_name {
	true
}

function q_units { 
	N="$1" # Nodes
	RPN="$2" # MPI ranks per node
	CPR="$3" # CPUs per rank
	GPR="$4" # GPUs per rank
	if test "1" -lt "$N"
	then
		echo "Running on more then one node in local is not supported" >&2
		exit 2
	fi
	MPI_OPTS="$MPI_OPTS -np $RPN"
	true
}

function q_walltime {
	true
}

function q_qos {
	true
}

function q_grant {
	true
}

function q_queue {
	true
}

function q_mem {
	true
}

function q_batch {
	bash "$@"
}

function q_run {
	if $ONLY_PRINT
	then
		cat $1 | display_scr
	else
		bash "$@"
	fi
}

