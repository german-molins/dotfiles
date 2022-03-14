_list ()
{
	local -r flagfile="$1"
	local -r dir="${2:-.}"

	find "$dir" \
		-mindepth 1 \
		-maxdepth 1 \
		! -name "$flagfile"
}

find_by_flagfile ()
{
	local -r flagfile="$1"
	local -- dir="${2:-.}"

	local -- file
	local -i found_here
	local -i found_rec

	if [ -f "$dir/$flagfile" ]
	then
		found_here=1
	fi

	for file in $(_list "$flagfile" "$dir")
	do
		if [ -f "$file" ]
		then
			if ((found_here))
			then
				echo "$file"
			fi
		elif [ -d "$file" ]
		then
			dir="$file"
			if ! ( find_by_flagfile "$flagfile" "$dir" )
			then
				if ((found_here))
				then
					echo "$dir"
				fi
			else
				found_rec=1
			fi
		fi
	done

	if ((found_here || found_rec))
	then
		return 0
	else
		return 1
	fi
}

_symlink_parents_ ()
{
	local -r dest_dir="$1"
	local -r file="$2"

	local -- dir
	local -- target
	local -- symlink

	target="$(realpath "$file")"
	filename="$(basename "$file")"
	dir="$(dirname "$file" | grep -vx .)"
	dir="$dest_dir/$dir"
	symlink="${dir%/}/$filename"

	mkdir -p "$dir"
	ln -s "$target" "$symlink"
}

symlink_parents ()
{
	local -r dest_dir="$1"
	local -- file

	while read file
	do
		_symlink_parents_ "$dest_dir" "$file"
	done
}

symlink_tree ()
(
	local -r flagfile="$1"
	local -r source_dir="$(realpath "$2")"
	local -r dest_dir="$(realpath "$3")"

	cd "$source_dir"
	find_by_flagfile "$flagfile" . |
	symlink_parents "$dest_dir"
)
