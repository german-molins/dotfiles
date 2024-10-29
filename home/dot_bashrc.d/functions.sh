#################################################
# Generic functions for everyday use
#################################################

###
# Change working directory to parent N times.
# POSIX compatible
###
.. ()
{
	cd $(printf "%${1:-1}s" | sed 's: :../:g')
}

ls, () {  ls "$@" | less -FX; }

egr () { egrep "$1" **/*."$2"; }

###
# Print path to working dir from this depth up to n levels above.
# Special cases:
#     n = "" or unset is equiv to `pwd`
#     n = 0 is equiv to command `pwd|xargs basename`
#     n > path_depth is equiv to n = path_depth
###
pwd ()
{
	declare n="$1"
	declare f

	f=$(builtin pwd | tr / \ | wc -w)
	if [ -z $n ] || ((n > f))
	then
			n=$f
	fi
	builtin pwd | cut -f $((f + 1 - n))-
}

###
# List dir's contents (default wd) or view file's contents.
###
, ()
{
	local f="${1:-.}"

	if [ $# -gt 1 ]
	then
		>&2 echo "error: none or one argument admitted"
		return 1
	fi

	if [ -f "$f" ]
	then
		less "$f"
	elif [ -d "$f" ]
	then
		lc "$f"
	else
		>&2 echo "error: pass directory or regular file"
	fi
}

###
# If there is only one tmux session, attach to it; else list sessions.
###
txa ()
{
	local session

	case $# in
	(0)
		if [ $(tmux ls | wc -l) -eq 1 ]
		then
			tmux attach
		else
			tmux ls
			return 1
		fi
		;;
	(1)
		session="$1"
		tmux attach -t "$session"
		;;
	(*)
		>&2 echo "only zero or one argument allowed"
		;;
	esac
}

###
# Copy directory tree structure from source dir to dest dir--latter need not
# exist.
###
cptree ()
(
	local source="$1"
	local dest="$2"
	local dir

	if [ ! -d "$source" ]
	then
		>&2 echo "Source must be a directory."
		return 1
	fi
	if [ -e "$dest" ] && [ ! -d "$dest" ]
	then
		>&2 echo "Dest must be a directory."
		return 2
	fi

	dest="$(realpath "$dest")"
	cd "$source"
	for dir in $(find -type d)
	do
		mkdir -p "$dest"/"$dir"
	done
)

###
# Iteratively look for a file in the directory tree, starting from
# the working directory upward.
#
# Arguments:
#     $1      filename to search for
###
find_upward ()
(
	local file="$1"

	while [ "$PWD" != / ]
	do
		if [ -f "$file" ]
		then
			realpath "$file"
			return
		else
			cd ..
		fi
	done
	return 1
)

###
# Mechanism to clear screen when user hits Enter with null or whitespace
# command
###
_empty_cmd_check ()
{
    if [ "$BASH_COMMAND" != _empty_cmd_exec ]
    then
        EMPTY_CMD_FLAG=1
    fi
    return 0
}

trap _empty_cmd_check DEBUG SIGINT

_empty_cmd_exec ()
{
    if [ ! "$EMPTY_CMD_FLAG" ]
    then
		eval "$EMPTY_CMD"
    fi
    EMPTY_CMD_FLAG=
}
PROMPT_COMMAND=_empty_cmd_exec
###

###
# Find leaf directories under a directory tree structure.
###
find_leaves ()
{
	local -r dir="${1:-.}"

	find "$dir" -type d |
	sort -r |
	awk 'index(s, $0) != 1 { s = $0; print }' |
	sort
}
