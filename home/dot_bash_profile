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
