# rysy\.icm\.edu\.pl

echo -e "You are on the RYSY cluster."
echo -e "Singularity container with TCLB can be used here instead of modules. \n"


#https://cloud.sylabs.io/library/mdzik/default/tclb
echo -e "Make sure that you have downloaded the 'singularity TCLB image' before you run the job."
echo -e "TIP: If not, call '\$ singularity pull --arch amd64 library://mdzik/default/tclb:latest' from a computational node.'"
echo -e "Please, keep the github repo and container in $HOME/TCLB/ \n\n"


# Rysy - hardware info:
# CPU type: Intel Skylake
# GPU type: NVIDIA Volta
# No of nodes: 6
# No of cores per node: 36
# No of GPUs per node: 4
# CPU Memory per node: 380 GB


# All jobs are run inside singularity container, thus no modules need to be loaded.
fix MODULES_ADD ""  
fix MODULES_ADD ""
fix MODULES_RUN ""
fix MODULES_BASE ""

# there isn't much traffic on rysy, use default qos
fix MAINQ "" # "normal" is default
fix DEBUGQ "" # "short" is not quick ;p

function RUN_GPU_CHECK {
	case "$RUN_GPU" in
	y)
		echo -e "[y] has been choosen."
		def SINGULARITY_COMMAND "singularity exec --nv $HOME/TCLB/tclb_latest.sif"
		def RUN_COMMAND "mpirun"
		def CONFOPT "--enable-double --enable-cpp11 --with-cuda-arch=sm_60"
		def MAX_TASKS_PER_NODE 4
		def MAX_TASKS_PER_NODE_FOR_COMPILATION 24
		def CORES_PER_TASK_FULL 1
		def MEMORY_PER_CORE 5
		;;
	*)
		echo "RUN_GPU should be y! Only GPU jobs shall run on RYSY"
		return 1;
	esac
	return 0
}
