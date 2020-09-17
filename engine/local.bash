BATCH=false

function q_header {
	echo "#!/bin/bash"
}

function q_option {
	true
}

function q_name {
	true
}

function q_units { 
	if test "1" -lt "$1"
	then
		echo "Running on more then one node in local is not supported"
		exit 2
	fi
	true
}

function q_walltime {
	true
}

function q_qos {
	true
}

function q_grant {
	true
}

function q_queue {
	true
}

function q_batch {
	if $ONLY_PRINT
	then
		display_scr
	else
		bash "$@"
	fi
}

function q_wait {
	cat
}
