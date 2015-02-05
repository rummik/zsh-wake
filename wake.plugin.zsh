#!/bin/zsh

function wake {
	emulate -L zsh

	cmd=${1:-help}
	[[ $# -gt 0 ]] && shift

	if [[ ! -d ~/.wake ]]; then
		mkdir -p ~/.wake
	fi

	if ! whence -- "-wake-$cmd" > /dev/null; then
		-wake-up $cmd
	else
		"-wake-$cmd" $@
	fi
}

function -wake-list {
	ls ~/.wake
}

function -wake-help {
	<<-EOF
	Usage
	    wake [up] <host>
	    wake add <host> <mac>
	    wake update <host> <mac>
	    wake delete <host>
	    wake list
	EOF
}

function -wake-up {
	local host=$1 file=~/.wake/$1

	if [[ ! -f $file ]]; then
		print "$host doesn't exist"
	else
		print waking $host
		wakeonlan -f $file
	fi
}

function -wake-add {
	local host=$1 file=~/.wake/$1 mac=$2

	if [[ ! -f $file ]]; then
		print $mac > $file
		print added $host
	else
		print $host already exists
	fi
}

function -wake-update {
	local host=$1 file=~/.wake/$1 mac=$2

	if [[ ! -f $file ]]; then
		print "$host doesn't exist"
	else
		print $mac > $file
		print updated $host
	fi
}

function -wake-remove {
	local file=~/.wake/$1

	if [[ ! -f $file ]]; then
		print "$host doesn't exist"
	else
		rm $file
		print removed $host
	fi
}
