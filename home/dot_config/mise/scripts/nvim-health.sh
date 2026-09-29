#!/usr/bin/env sh
set -eu

out="$(mktemp)"
trap 'rm -f "$out"' EXIT

nvim --headless \
    -c 'Lazy! load mason.nvim nvim-treesitter' \
    -c 'checkhealth vim.* lazy nvim-treesitter mason' \
    -c "w! $out" \
    -c 'qa!' >/dev/null 2>&1

[ -s "$out" ] && ! grep -q ERROR "$out"
