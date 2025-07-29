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
	if !isempty(PROGRAM_FILE)  # CLI
		# ...
	else  # REPL
		# ...
	end
end
