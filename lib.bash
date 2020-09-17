# BASH

agree=false
def=false

function source_conf {
	if [ -f "$PP/conf.ini" ]
	then
		source $PP/conf.ini
	fi
}

function save_conf {
	OLD="$PP/conf.ini"
	NEW="$PP/new.conf.ini"
	echo -n "Saving conf... "
	if [ -f "$NEW" ]
	then
		if [ -f "$OLD" ]
		then
			if diff "$NEW" "$OLD" >/dev/null
			then
				echo "nothing new"
			else
				mv "$NEW" "$OLD"
				echo "ok"
			fi
		else
			mv "$NEW" "$OLD"
			echo "ok"
		fi
	else
		echo "no new conf"
	fi
}
		
function find_cluster {
	for i in $(cd $PP/cluster/; ls *.bash)
	do
		hn=$(head -n 1 $PP/cluster/$i | sed 's/^ *# *//')
		if hostname | grep "$hn" >/dev/null
		then
			echo $i | sed 's/.bash$//'
		fi
	done
}

function source_cluster {
	if test -z "$CLUSTER"
	then
		true	
	elif test -f "$PP/cluster/$CLUSTER.bash"
	then
		source "$PP/cluster/$CLUSTER.bash"
	else
		echo "Cluster defaults '$CLUSTER' not found in cluster/:"
		(cd $PP/cluster/; ls)
		exit 3;
	fi
}

function source_engine {
	ENG="$1"
	if test -z "$ENG"
	then
		ENG="$ENGINE_RUN"
	fi
	if test -f "$PP/engine/$ENG.bash"
	then
		source "$PP/engine/$ENG.bash"
	else
		echo "Engine '$ENG' not found in engine/:"
		(cd $PP/engine/; ls)
		exit 3;
	fi
}

function : {
	if test -z "$2"
	then
		var="$1"
	else
		var="$1_$2"
	fi
	echo ${!var}
}

function ask_init {
	true >$PP/new.conf.ini
}

function ask {
	VAR="$1"
	shift
	COMM="$1"
	VAL="$(: $VAR)"
	ASK="$(: $VAR ASK)"
	DEF="$(: $VAR DEF)"
	OLDDEF="$(: $VAR OLDDEF)"
	CHECK="${VAR}_CHECK"
#	echo "var:$VAR | val:$VAL | ask:$ASK | def:$DEF | check:$CHECK"
	if $def || test "x$DEF" != "x$OLDDEF"
	then
		VAL="$DEF"
	fi
	case "$ASK-$advanced" in
	-*|advanced-true)
		if $agree
		then
			echo "$COMM: $VAL"
		else
			read -e -p "$COMM: " -i "$VAL" NEW
			VAL=$NEW
		fi
		;;
	yn-*|advancedyn-true)
		if ask_yn "$DEF" "$COMM"
		then
			VAL="y"
		else
			VAL="n"
		fi
		;;
	*)
		VAL="$DEF"
		;;
	esac
	eval "$VAR=\"$VAL\""
	if test "x$(type -t "$CHECK")" == "xfunction"
	then
		if test "x$ASK" != "xfix"
		then
			if ! $CHECK "$VAL"
			then
				exit -1;
			fi
		fi
	fi
	echo "${VAR}=\"${VAL}\"" >>$PP/new.conf.ini
	echo "${VAR}_OLDDEF=\"${DEF}\"" >>$PP/new.conf.ini
}

function defgrant {
        sacctmgr -p --quiet list User $USER | sed -n 2p | cut -d '|' -f 2 | tail -n1
}

function checkgrant {
        [ -z "$1" ] && return 1
        NL=$(sacctmgr --quiet list Account "$1" | wc -l)
        [ $NL -ne 3 ] && return 1
        return 0
}

function ask_yn {
	DEF=$1
	shift
	MSG=$1
	if $agree
	then
		echo "$MSG: $DEF"
		REP="$DEF"
	else
		MSG="$MSG [$DEF]"
		echo -n "$MSG: "
		read REP
	fi
	case "$REP" in
	y|Y|yes|Yes|YES) RET=y;;
	n|N|no|NO) RET=n;;
	"") RET=$DEF;;
	*)
		echo "Say yes or no" >&2
		exit -1
	esac
	if test "$RET" == "y"
	then
		return 0;
	else
		return 1;
	fi
}

function ask_yes {
	ask_yn y "$@"
}
function ask_no {
	ask_yn n "$@"
}

function def {
	if test "$(: ${1} ASK)" != "no"
	then
		eval "${1}_DEF=\"$2\""
		eval "${1}_ASK=\"$3\""
	fi
}

function adv {
	if test "$(: ${1} ASK)" != "no"
	then
#		echo "Setting $1 to advance with default $2"
		eval "${1}_DEF=\"$2\""
		eval "${1}_ASK=\"advanced$3\""
	fi
}

function fix {
	eval "${1}_DEF=\"$2\""
	eval "${1}_ASK=\"no\""
}

function module_list {
	for i in $@
	do
		case "$i" in
		-*)
			echo "module unload" ${i:1}
			;;
		purge)
			echo "module purge"
			;;
		*)
			echo "module load" $i
			;;
		esac
	done
}


function arg {
	if ! test -z "$2"
	then
		echo "$1" "$2"
	fi
}

function check_integer {
	if ! test "$1" -eq "$1" 2>/dev/null
	then
		echo "'$1' not an integer"
		exit 2
	fi
}

function display_scr {
	echo
	sed -E -e 's/$/\x1B[0m/' -e 's/^([^#][^#]*)/\x1B[93m\1/' -e 's/(#.*)$/\x1B[32m\1/' -e 's/(#SBATCH|#PBS) /\1 \x1B[92m/'
	echo
}

#SCRIPT=$(mktemp)
#function rm_script {
#	if test -f "$SCRIPT"
#	then
#		echo "Deleting script"
#		rm $SCRIPT
#	fi
#}
#trap rm_script EXIT

	