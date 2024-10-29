dir="$(realpath $BASH_SOURCE | xargs dirname)"
dir+=/modules
if [ -d "$dir" ]
then
	dir="$(realpath "$dir")"
	declare -r MODULES_DIR="$dir"
else
	echo "error: modules directory not found" >&2
fi
unset dir

###
# Module name: Hyphen and underscore are treated indifferently.
###
load ()
{
	local -r module="${1//-/_}"
	shift
	if source "$MODULES_DIR/${module}.sh" "$@"
	then
		PS1="<$module>$PS1"
	fi
}

###
# Re-load module, useful for debugging purposes, e.g. when implementing a new
# module user function.
###
reload ()
{
	local -r module="${1//-/_}"
	source "$MODULES_DIR/${module}.sh" reload
}
