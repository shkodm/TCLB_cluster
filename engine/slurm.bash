function q_header {
	echo "#!/bin/bash" "$@"
	BATCH=true
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

function q_mem {
	N="$1" # Nodes
	RPN="$2" # MPI ranks per node
	MPR="$3" # mem per rank
	test -z "$3" || q_option "--mem=$[$RPN * $MPR]G"
}

function q_batch {
	sbatch "$@"
}

function q_wait {
	JOBID="$1"
	test -z "$1" && exit -1
	echo "Submitted job $JOBID to queue and waiting"
	OUT="slurm-$JOBID.out"
	RES=false
	function ctrl_c {
		agree="false"
		echo; echo;
		if ask_no "Do you want to kill job $JOBID ($STATE)? "
		then
			scancel "$JOBID"
		fi
		exit 2
	}
	trap ctrl_c INT
	while sleep 5
	do
		STATE="$(sacct -j $JOBID -o 'state' --parsable2 --noheader | head -1)"
		case "$STATE" in
			RUNNING) update_log "$OUT";;
			PENDING) ;;
			CONFIGURING) ;;
			FAILED) break ;;
			COMPLETED) RES=true; break ;;
			*) echo " unknown: '$STATE'"; break ;;
		esac
	done
	update_log "$OUT"
	$RES
}

function q_run {
	if $ONLY_PRINT
	then
		display_scr "$@"
	else
		JOBID=$(sbatch --parsable "$@")
		if $RUN_WAIT
		then
			q_wait $JOBID
		else
			echo "Submitted job $JOBID to queue"
		fi
	fi
}
