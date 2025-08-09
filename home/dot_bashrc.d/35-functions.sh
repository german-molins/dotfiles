#################################################
# Generic functions for everyday use
#################################################

where()
{
    cat <<-EOF
	host  : $HOSTNAME
	user  : $USER
	shell : bash $BASH_VERSION
	wd    : $PWD

	EOF
}
alias wh=where

###
# List dir's contents (default wd) or view file's contents.
###
,()
{
    local f="${1:-.}"

    if [ $# -gt 1 ]; then
        >&2 echo "error: none or one argument admitted"
        return 1
    fi

    if [ -f "$f" ]; then
        less "$f"
    elif [ -d "$f" ]; then
        lc "$f"
    else
        >&2 echo "error: pass directory or regular file"
    fi
}

###
# Copy directory tree structure from source dir to dest dir--latter need not
# exist.
###
cptree()
(
    local source="$1"
    local dest="$2"
    local dir

    if [ ! -d "$source" ]; then
        >&2 echo "Source must be a directory."
        return 1
    fi
    if [ -e "$dest" ] && [ ! -d "$dest" ]; then
        >&2 echo "Dest must be a directory."
        return 2
    fi

    dest="$(realpath "$dest")"
    cd "$source"
    for dir in $(find -type d); do
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
find_upward()
(
    local file="$1"

    while [ "$PWD" != / ]; do
        if [ -f "$file" ]; then
            realpath "$file"
            return
        else
            cd ..
        fi
    done
    return 1
)

###
# Find leaf directories under a directory tree structure.
###
find_leaves()
{
    local -r dir="${1:-.}"

    find "$dir" -type d \
        | sort -r \
        | awk 'index(s, $0) != 1 { s = $0; print }' \
        | sort
}
