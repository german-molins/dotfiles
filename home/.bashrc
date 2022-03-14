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
export VISUAL="$EDITOR"
export PAGER=less

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
