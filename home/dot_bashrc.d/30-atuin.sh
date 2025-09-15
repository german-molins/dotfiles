if [[ -f ~/.bash-preexec.sh ]]; then
    source ~/.bash-preexec.sh
    eval "$(atuin init bash)"
fi
