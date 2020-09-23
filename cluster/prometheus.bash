# .*\.prometheus\.cyfronet\.pl

echo
echo "You are on the Prometheus cluster"
echo

adv ENGINE_CONF slurm
adv ENGINE_MAKE slurm
adv ENGINE_RUN  slurm
def CONFOPT ""
adv DEBUG_PARTITION "plgrid-testing"
fix DEBUG_QOS ""
fix MAIN_QOS ""
fix RUN_COMMAND "mpirun"
fix MODULES_BASE ""
fix RUN_SINGULARITY "n"
fix SINGULARITY_COMMAND ""

# Prometheus - hardware info:
# Processors per node:  2x Intel Xeon E5-2680v3 
# Cores per node 24
# Memory per node: 128 GB --> default setting is 5GB per core
# GPU per node: 2x Nvidia Tesla K40 XL

function RUN_GPU_CHECK {
	case "$RUN_GPU" in
	y)
		adv MAIN_PARTITION "plgrid-gpu"
		def MODULES_RUN "plgrid/apps/r/3.4.4 plgrid/tools/openmpi/3.0.0-gcc-4.9.2 plgrid/apps/cuda/9.0"
		def CONFOPT "--with-cuda-arch=sm_30"
		adv MAX_TASKS_PER_NODE 2
		adv MAX_TASKS_PER_NODE_FOR_COMPILATION 24
		adv CORES_PER_TASK_FULL 1
		def MEMORY_PER_TASK 120
		;;
	n)
		adv MAIN_PARTITION "plgrid"
		def MODULES_RUN "plgrid/tools/openmpi/2.1.1-gcc-6.4.0"
		def CONFOPT "--disable-cuda"
		adv MAX_TASKS_PER_NODE 12
		adv MAX_TASKS_PER_NODE_FOR_COMPILATION 12
		adv CORES_PER_TASK_FULL 1
		def MEMORY_PER_TASK 10
		;;
	*)
		echo "RUN_GPU should be y or n!"
		return 1;
	esac
	return 0
}

def MODULES_ADD "plgrid/apps/r/3.4.4 plgrid/apps/cuda"  
# Prometheus's module apps/r loads apps/cuda/9.0 as dependency. 
# apps/r (with its dependencies) must be called first with $MODULES_ADD, then override (prepend path) with $MODULES_RUN

adv MODULES_CHECK_AVAILABILITY "y"
