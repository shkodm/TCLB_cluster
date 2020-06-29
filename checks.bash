function GRANT_CHECK {
	if [ -z "$GRANT" ]
	then
		echo No grant provided.
		return 0
	fi
#	if ! checkgrant $GRANT
#	then
#		echo No such grant: $GRANT
#		return 1
#	fi
	return 0
}


function TCLB_CHECK {
	if [ ! -d "$TCLB/src" ]
	then
		echo there is no src subdirectory - something is wrong
		echo file not found: $TCLB/src
		return 1;
	else
		TCLB=$(cd $TCLB; pwd)
	fi
	return 0
}

function RHOME_CHECK {
    if [ ! -f "$RHOME/bin/R" ]
    then
            echo R not found in $RHOME/bin/
            return 1
    fi
    return 0
}


function ARE_U_ON_RYSY {
	if hostname | grep "rysy\.icm\.edu\.pl" >/dev/null
	then
		return 0
	fi
    return 1
}

function MODULES_CHECK {
	if ! ARE_U_ON_RYSY
	then
		for i in $@
		do
				if [ -z "$(module av $i 2>&1)" ]
				then
						echo there is no module $i
						return 1;
				fi
		done
	else
		echo "On RYSY modules shall be checked on computational node"  # todo
	fi
    return 0;
}

function MODULES_RUN_CHECK {
	MODULES_CHECK $MODULES_RUN
}

function MODULES_ADD_CHECK {
	MODULES_CHECK $MODULES_ADD
}

