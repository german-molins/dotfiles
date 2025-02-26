# Set shell env.
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv 2>/dev/null)"

if [ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]; then
  . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
fi
