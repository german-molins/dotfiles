###
# Pluto notebook
###
function pluto
{
    local kwargs=""
    local notebook

    if [ $# -eq 1 ]; then
        notebook="$1"
        kwargs="notebook=\"$notebook\""
    fi

    julia --project=@. -e "
	using Pluto: run
	run($kwargs)
	"
}

###
# Jupyter Lab notebook
###
function ijulia
{
    local detached=true

    if [ $# -eq 1 ]; then
        detached="$1"
    fi

    julia --project=@. -e "
	using IJulia: jupyterlab
	jupyterlab(dir=pwd(), detached=$detached)
	"
}
