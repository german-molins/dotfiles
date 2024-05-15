where ()
{
	cat <<- EOF
	host  : $HOSTNAME
	user  : $USER
	shell : bash $BASH_VERSION
	wd    : $PWD

	EOF
}

for f in ~/.bashrc.d/*.sh 
do
	if [ -r "$f" ]
	then
		source "$f"
	fi
done

if [ -r /etc/bash_completion ] && ! shopt -oq posix
then
    source /etc/bash_completion
fi

### Envvars ### 

export PS1=': '
export PS2='.. '

export PATH
PATH="$HOME/.local/bin/:$PATH"

export EDITOR=vim
export VISUAL=gvim
export PAGER=less
export JULIA_PROJECT=@.

### User Envvars ###

# Command to evaluate after entering empty or whitespaces command
EMPTY_CMD=clear

### Interactive Shell Options ###

shopt -s extglob
shopt -s globstar
#shopt -s nullglob

shopt -s autocd
shopt -s cdspell
shopt -s cdable_vars

shopt -s checkjobs

set -o noclobber
set -o vi

###

where

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/etc/profile.d/conda.sh" ]; then
        . "/usr/etc/profile.d/conda.sh"
    else
        export PATH="/usr/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

case ":$PATH:" in
    *:/home/german/.opt/juliaup/bin:*)
        ;;

    *)
        export PATH=/home/german/.opt/juliaup/bin${PATH:+:${PATH}}
        ;;
esac

# <<< juliaup initialize <<<
