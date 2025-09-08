#!/bin/bash

set -eu

# Make mise available in the current shell.
PATH="$HOME/.local/bin:$PATH"

mise plugin install devbox "https://github.com/jbadeau/mise-nix.git" --quiet
