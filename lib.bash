# BASH

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
	for i in $PP/cluster/*
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
	VAR=$1
	shift
	COMM=$1
	VAL="$(: $VAR)"
	ASK="$(: $VAR ASK)"
	if test -z "$ASK"
	then
		if test -z "$VAL"
		then
			VAL="$(: $VAR DEF)"
		fi
		if ! test -z "$VAL"
		then
			O=" [$VAL]"
		fi
		#echo -n "$COMM$O: " >&2
		#read NEW
		#if ! test -z "$NEW"
		#then
		#	VAL=$NEW
		#fi
		read -e -p "$COMM: " -i "$VAL" NEW
		VAL=$NEW
	else
		VAL="$(: $VAR DEF)"
	fi
	eval "$VAR=\"$VAL\""
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
	if ! test -z "$1"
	then
		MSG="$MSG [$DEF]"
	fi
	echo -n "$MSG: "
	read REP
	case "$REP" in
	y|Y|yes|Yes|YES) RET=y;;
	n|N|no|NO) RET=n;;
	"") RET=$DEF;;
	*)
		echo "Say yes of no" >&2
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
