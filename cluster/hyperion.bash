# hyp-.*

echo "You are on the Hyperion cluster"

CONFOPT_DEF=""
DEBUG_PARTITION_DEF="cpus"
DEBUG_PARTITION_ASK="no"
RUN_COMMAND_DEF="mpirun"
RUN_COMMAND_ASK="no"
MODULES_BASE_ASK="no"

function RUN_GPU_CHECK {
	case "$RUN_GPU" in
	y)
		MAIN_PARTITION_DEF="gpus"
		MODULES_RUN_DEF="hyp/CUDA/10.1 hyp/mpi/openmpi/4.0.1"
		CONFOPT_DEF="--with-cuda-arch=sm_30"
		MAX_TASKS_PER_NODE_DEF=2
		CORES_PER_TASK_FULL_DEF=1
		MAX_TASKS_PER_NODE_ASK="no"
		CORES_PER_TASK_FULL_ASK="no"
		;;
	n)
		MAIN_PARTITION_DEF="cpus"
		MODULES_RUN_DEF="hyp/mpi/openmpi/4.0."
		CONFOPT_DEF="--disable-cuda"
		MAX_TASKS_PER_NODE_DEF=32
		CORES_PER_TASK_FULL_DEF=1
		MAX_TASKS_PER_NODE_ASK="no"
		CORES_PER_TASK_FULL_ASK="no"
		;;
	*)
		echo "RUN_GPU should be y or n!"
		return 1;
	esac
	return 0
}
MAIN_PARTITION_ASK="no"

MODULES_ADD_DEF=""
MODULES_ADD_ASK="no"
MODULES_RUN_ASK="no"

GRANT_DEF=""
GRANT_ASK="no"
