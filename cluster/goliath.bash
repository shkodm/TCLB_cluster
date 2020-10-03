# .*goliath\.labs\.eait\.uq\.edu\.au

echo
echo "You are on the Goliath cluster, UQ, Australia"
echo

adv RUN_GPU y
adv ENGINE_CONF local
adv ENGINE_MAKE local
adv ENGINE_RUN  slurm
adv DEBUG_PARTITION "batch"
fix RUN_COMMAND "mpirun"

# https://rcc.uq.edu.au/high-performance-computing

function RUN_GPU_CHECK {
	case "$RUN_GPU" in
	y)
		adv MAIN_PARTITION "gpu"
		def MODULES_RUN "mpi/openmpi-x86_64 cuda/10.1"
		def CONFOPT "--with-cuda-arch=sm_35"
		adv MAX_TASKS_PER_NODE 4
		adv MAX_TASKS_PER_NODE_FOR_COMPILATION 6
		adv CORES_PER_TASK_FULL 1
		def MEMORY_PER_TASK 50
		;;
	n)
		echo "CPU not yet supported on goliath"
		return 1;
		;;
	*)
		echo "RUN_GPU should be y or n!"
		return 1;
	esac
	return 0
}

adv MODULES_CHECK_AVAILABILITY "y"
