# .*\.pro\.cyfronet\.pl

echo "You are on the Prometheus cluster"

CONFOPT_DEF=""
DEBUGQ_DEF="plgrid-testing"
DEBUGQ_ASK="no"
RUN_COMMAND="mpirun"
RUN_COMMAND_ASK="no"

function RUN_GPU_CHECK {
	case "$RUN_GPU" in
	y)
		MAINQ_DEF="plgrid-gpu"
		MODULES_RUN_DEF="apps/cuda/9.0 tools/openmpi/2.0.1-gcc-4.9.2"
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
		MODULES_RUN_DEF="tools/openmpi/2.0.1-gcc-4.9.2"
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
MODULES_ADD_DEF="apps/r"
MODULES_ADD_ASK="no"
MODULES_RUN_ASK="no"
