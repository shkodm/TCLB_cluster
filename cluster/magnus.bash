# magnus-.*

echo "Running on Magnus."

fix RUN_COMMAND "srun"
fix DEBUG_PARTITION "debugq"
fix MAIN_PARTITION "workq"
fix RUN_GPU "n"
function RUN_GPU_CHECK {
	case "$RUN_GPU" in
	y)
		echo "gpu not supported on Magnus" >&2
		return 1
		;;
	n)
                def MODULES_RUN "PrgEnv-gnu"
                fix MODULES_BASE "-PrgEnv-cray"
                def CONFOPT "--disable-cuda --with-cpp-flags='-O2' CXX=CC CC=cc"
                fix MAX_TASKS_PER_NODE 24
                fix CORES_PER_TASK_FULL 1
                fix MODULES_ADD ""
		;;
	*)
		echo "RUN_GPU should be y or n!"
		return 1;
	esac
	return 0
}
fix PREPARE "ulimit -S -s 81920"
def ADD_PATH "$(ls /opt/R/*/bin/R | tail -1 | sed 's|R$||')"
def MAX_TASKS_PER_NODE_FOR_COMPILATION 8 # Limit compilation to 8 cores
