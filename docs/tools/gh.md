# GitHub CLI

## Extensions

`gh` extensions are **not** installed with `gh extension install`. Each is a
[mise](./mise) tool (so it is version-pinned in `mise.lock` and updated through
the single `mise` update path) plus a chezmoi-managed symlink to its mise
shim that makes `gh` discover it.

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

2. Add the symlink `home/dot_local/share/gh/extensions/gh-<name>/symlink_gh-<name>.tmpl`
   pointing at the tool's mise shim:

   ```
   {{ .chezmoi.homeDir }}/.local/share/mise/shims/gh-<name>
   ```

   The shim path is stable across upgrades, `mise prune` and backend switches,
   and does not depend on the PATH chezmoi runs with. An extension not
   installed via mise has no shim; resolve it from PATH instead, and re-run
   `chezmoi apply` from a fresh shell after upgrading it:

   ```
   {{ lookPath "gh-<name>" }}
   ```

3. `chezmoi apply` then `mise install`, and commit the updated `mise.lock`.
