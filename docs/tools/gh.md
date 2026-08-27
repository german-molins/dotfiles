# GitHub CLI

## Extensions

`gh` extensions are **not** installed with `gh extension install`. Each is a
[mise](./mise) tool (so it is version-pinned in `mise.lock` and updated through
the single `mise` update path) plus a chezmoi-managed `symlink_` shim that makes
`gh` discover it.

| Extension | Command |
|------|---------|
| [gh-dash](https://www.gh-dash.dev) | `gh dash` |
| [gh-stack](https://github.com/github/gh-stack) | `gh stack` |

### Adding one

1. Add the binary to `home/dot_config/mise/config.toml`, ensuring it resolves on
   PATH as `gh-<name>`:

   ```toml
   # aqua registry (preferred when available):
   "aqua:owner/gh-foo" = "latest"
   # github releases (bare binary → set bin so PATH name is gh-foo):
   "github:owner/gh-foo" = { version = "latest", bin = "gh-foo" }
   ```

   Use `bin` / `rename_exe` when the release asset is not already named
   `gh-<name>` (see the [github backend docs](https://mise.jdx.dev/dev-tools/backends/github.html)).

2. Add the shim `home/dot_local/share/gh/extensions/gh-<name>/symlink_gh-<name>.tmpl`:

   ```
   {{ lookPath "gh-<name>" }}
   ```

3. `chezmoi apply` then `mise install`, and commit the updated `mise.lock`.
