if [[ -f ~/.bash-preexec.sh ]]; then
    source ~/.bash-preexec.sh
    eval "$(_evalcache atuin init bash)"
fi
