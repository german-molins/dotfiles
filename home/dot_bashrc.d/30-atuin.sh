[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
if command -v atuin &>/dev/null; then
    eval "$(atuin init bash)"
fi
