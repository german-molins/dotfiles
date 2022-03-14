# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

if [ -n "$BASH_VERSION" ]
then
    if [ -f "$HOME/.bashrc" ]
	then
		source "$HOME/.bashrc"
    fi
fi

if [ -d "$HOME/bin" ]
then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]
then
    PATH="$HOME/.local/bin:$PATH"
fi

for f in $HOME/.profile.d/*.sh ; do
    if [ -r "$f" ]; then
        if [ "$PS1" ]; then
            . "$f"
        else
            . "$f" >/dev/null
        fi
    fi
done
unset f