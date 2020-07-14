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
		
function source_cluster {
	for i in $PP/cluster/*.bash
	do
		hn=$(head -n 1 $i | sed 's/^ *# *//')
		if hostname | grep "$hn" >/dev/null
		then
			source $i
		fi
	done
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
	CHECK="${VAR}_CHECK"
	#echo "var:$VAR | val:$VAL | ask:$ASK | def:$DEF | check:$CHECK"
	if $def || test -z "$VAL"
	then
		VAL="$DEF"
	fi
	if test -z "$ASK"
	then
		if ! test -z "$VAL"
		then
			O=" [$VAL]"
		fi
		if $agree
		then
			echo "$COMM: $VAL"
		else
			read -e -p "$COMM: " -i "$VAL" NEW
			VAL=$NEW
		fi
	elif test "$ASK" == "yn"
	then
		if ask_yn "$DEF" "$COMM"
		then
			VAL="y"
		else
			VAL="n"
		fi
	else
		VAL="$DEF"
	fi
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
	echo "$VAR=\"$VAL\"" >>$PP/new.conf.ini
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
	eval "${1}_DEF=\"$2\""
	eval "${1}_ASK=\"\""
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
			echo "quiet_run module unload" ${i:1}
			;;
		purge)
			echo "quiet_run module purge"
			;;
		*)
			echo "quiet_run module load" $i
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
	