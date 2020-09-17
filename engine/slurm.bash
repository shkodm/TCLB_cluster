function q_header {
	echo "#!/bin/bash"
}

function q_option {
	if $BATCH
	then
		echo "#SBATCH" "$@"
	else
		echo "$@"
	fi
}

function q_name {
	test -z "$1" || q_option "--job-name=$1"
}

function q_units { 
	N="$1" # Nodes
	RPN="$2" # MPI ranks per node
	CPR="$3" # CPUs per rank
	GPR="$4" # GPUs per rank
	q_option "--nodes=$N"
	q_option "--ntasks=$[$RPN * $N]"
	q_option "--cpus-per-task=$CPR"
	q_option "--ntasks-per-node=$RPN"
	if test "0" -lt "$GPR"
	then
		q_option "--gres=gpu:$[$GPR * $RPN]"
	fi
}

function q_walltime {
	test -z "$1" || q_option "--time=$1"
}

function q_qos {
	test -z "$1" || q_option "--qos=$1"
}

function q_grant {
	test -z "$1" || q_option "--account=$1"
}

function q_queue {
	test -z "$1" || q_option "--partition=$1"
}

function q_batch {
	if $ONLY_PRINT
	then
		display_scr
	else
		sbatch "$@"
	fi
}

function q_wait {
	cat
}
