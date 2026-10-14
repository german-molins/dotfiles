wt() {
    unset -f wt
    eval "$(command wt config shell init bash)"
    wt "$@"
}
