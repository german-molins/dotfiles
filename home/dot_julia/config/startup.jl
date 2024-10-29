###
# To disable the loading of this startup file, use command-line option
#     --startup-file=no
###

# REPL startup
atreplinit() do repl
	let
		project = Base.load_path_expand("@")
		isnothing(project) && return

		SRC_DIRNAMES = ["src"]
		for src_dirname in SRC_DIRNAMES
			dir = dirname(project)
			dir = joinpath(dir, src_dirname)
			isdir(dir) && push!(LOAD_PATH, dir)
		end
	end

	try
		@eval using Revise
		@eval using Pipe: @pipe
	catch err
		showerror(stderr, err)
	end
end

let
	# program file
	if !isempty(PROGRAM_FILE)
		# ...
	# either command line or REPL
	else
		# ...
	end
end
