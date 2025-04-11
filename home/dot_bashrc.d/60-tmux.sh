# Function to update tmux status
__tmux_refresh()
{
    if [ -n "$TMUX" ]; then
        tmux refresh-client -S
    fi
}

# Add to preexec and precmd hooks
preexec_functions+=(__tmux_refresh)
precmd_functions+=(__tmux_refresh)
