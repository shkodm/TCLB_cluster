# .*\.prometheus\.cyfronet\.pl

echo "You are on the Prometheus cluster"

CONFOPT_DEF=""
DEBUG_PARTITION_DEF="plgrid-testing"
DEBUG_PARTITION_ASK="no"
DEBUG_QOS_ASK="no"
MAIN_QOS_ASK="no"
RUN_COMMAND_DEF="mpirun"
RUN_COMMAND_ASK="no"
MODULES_BASE_ASK="no"
RUN_SINGULARITY_ASK="no"
SINGULARITY_COMMAND_ASK="no"

# Prometheus - hardware info:
# Processors per node:  2x Intel Xeon E5-2680v3 
# Cores per node 24
# Memory per node: 128 GB --> default setting is 5GB per core
# GPU per node: 2x Nvidia Tesla K40 XL

function RUN_GPU_CHECK {
	case "$RUN_GPU" in
	y)
		MAIN_PARTITION_DEF="plgrid-gpu"
		MODULES_RUN_DEF="plgrid/apps/r/3.4.4 plgrid/tools/openmpi/3.0.0-gcc-4.9.2 plgrid/apps/cuda/9.0"
		CONFOPT_DEF="--with-cuda-arch=sm_30"
		MAX_TASKS_PER_NODE_DEF=2
		MAX_TASKS_PER_NODE_FOR_COMPILATION_DEF=12
		CORES_PER_TASK_FULL_DEF=1
		MEMORY_PER_CORE_DEF=10
		MAX_TASKS_PER_NODE_ASK="yes"
		MAX_TASKS_PER_NODE_FOR_COMPILATION_ASK='no'
		CORES_PER_TASK_FULL_ASK="no"
		MEMORY_PER_CORE_ASK="no"
		;;
	n)
		MAIN_PARTITION_DEF="plgrid"
		MODULES_RUN_DEF="plgrid/tools/openmpi/2.1.1-gcc-6.4.0"
		CONFOPT_DEF="--disable-cuda"
		MAX_TASKS_PER_NODE_DEF=12
		MAX_TASKS_PER_NODE_FOR_COMPILATION_DEF=12
		CORES_PER_TASK_FULL_DEF=1
		MEMORY_PER_CORE_DEF=10
		MAX_TASKS_PER_NODE_ASK="yes"
		MAX_TASKS_PER_NODE_FOR_COMPILATION_ASK='no'
		CORES_PER_TASK_FULL_ASK="no"
		MEMORY_PER_CORE_ASK="no"
		;;
	*)
		echo "RUN_GPU should be y or n!"
		return 1;
	esac
	return 0
}
MAIN_PARTITION_ASK="no"

MODULES_ADD_DEF="plgrid/apps/r/3.4.4 plgrid/apps/cuda"  
# Prometheus's module apps/r loads apps/cuda/9.0 as dependency. 
# apps/r (with its dependencies) must be called first with $MODULES_ADD, then override (prepend path) with $MODULES_RUN

MODULES_ADD_ASK="no"
MODULES_RUN_ASK="no"
MODULES_CHECK_AVAILABILITY="yes"
