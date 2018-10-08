# .*\.pro\.cyfronet\.pl

echo "You are on the Prometheus cluster"

CONFOPT_DEF=""
DEBUGQ_DEF="plgrid-testing"
DEBUGQ_ASK="no"
RUN_COMMAND_DEF="mpirun"
RUN_COMMAND_ASK="no"
MODULES_BASE_ASK="no"

function RUN_GPU_CHECK {
	case "$RUN_GPU" in
	y)
		MAINQ_DEF="plgrid-gpu"
		MODULES_RUN_DEF="plgrid/tools/openmpi/3.0.0-gcc-4.9.2 plgrid/apps/cuda/9.0"
		CONFOPT_DEF="--with-cuda-arch=sm_30"
		MAX_UNITS_PER_NODE_DEF=2
		CORES_PER_UNIT_DEF=1
		CORES_PER_UNIT_FULL_DEF=6
		MAX_UNITS_PER_NODE_ASK="no"
		CORES_PER_UNIT_ASK="no"
		CORES_PER_UNIT_FULL_ASK="no"
		;;
	n)
		MAINQ_DEF="plgrid"
		MODULES_RUN_DEF="plgrid/tools/openmpi/2.1.1-gcc-6.4.0"
		CONFOPT_DEF="--disable-cuda"
		MAX_UNITS_PER_NODE_DEF=12
		CORES_PER_UNIT_DEF=1
		CORES_PER_UNIT_FULL_DEF=1
		MAX_UNITS_PER_NODE_ASK="no"
		CORES_PER_UNIT_ASK="no"
		CORES_PER_UNIT_FULL_ASK="no"
		;;
	*)
		echo "RUN_GPU should be y or n!"
		return 1;
	esac
	return 0
}
MAINQ_ASK="no"

MODULES_ADD_DEF="plgrid/apps/r/3.4.4 -plgrid/apps/cuda"  
# Prometheus's module apps/r loads apps/cuda/9.0 as dependency. 
# apps/r (with its dependencies) must be called first $MODULES_ADD, then override with $MODULES_RUN

MODULES_ADD_ASK="no"
MODULES_RUN_ASK="no"
