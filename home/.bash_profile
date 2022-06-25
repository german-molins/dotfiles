# .bash_profile

if [ -r ~/.bashrc ]
then
	. ~/.bashrc
fi

if [ -r ~/.profile ]
then
	. ~/.profile
fi

PATH=$PATH:$HOME/.local/bin:$HOME/bin
export PATH
