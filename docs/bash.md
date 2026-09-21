# Bash Configuration

[Bash](https://www.gnu.org/software/bash/) is the interactive shell used in this
dotfiles setup.

## Bash Startup Files

The bash configuration is organized as follows:

- `~/.bashrc`: Main bash configuration file
- `~/.bashrc.d/*.sh`: Modular bash configuration files
- `~/.profile`: Login shell profile

## Non-Interactive Short-Circuit

`~/.bashrc` aborts on its first line for non-interactive shells, so **none** of
`~/.bashrc.d/*.sh` runs.

### Interactive vs non-interactive

These describe whether the shell reads commands from a prompt, independently of
whether it sources `~/.bashrc`:

- **Interactive** — a prompt you type at (`$-` contains `i`). E.g. `ssh host`
  with no command.
- **Non-interactive** — handed a one-off command and exits (no `i`). E.g.
  `ssh host '<cmd>'`, or the remote shells that `rsync`/`scp` spawn.

The guard keys off this property (`$-`), not off whether `~/.bashrc` was
sourced.

### The sshd abnormality

Normally a non-interactive bash does **not** read `~/.bashrc` at all. The
exception: when bash detects it was started by `sshd` it sources `~/.bashrc`
*even though it is non-interactive* (a compile-time feature enabled in
practically every build). So `rsync`/`scp`/`ssh host '<cmd>'` are
non-interactive — line editing is off, so `bind` warns — yet they abnormally
run `~/.bashrc`. Any stdout written during that sourcing corrupts the program's
stream; Atuin's init emitting a `bind` warning broke `rsync`:

```text
$ rsync -av some_file.txt remote-dotfiles-host:/home/user/dir
.bashrc.d/30-atuin.sh: line 747: bind: warning: line editing not enabled
protocol version mismatch -- is your shell clean?
```

The guard keeps the stream clean and makes these one-off shells start instantly.

### Limitation

Skipping `~/.bashrc.d/` means tooling activated there (`mise`, `nix`,
`homebrew`) is unavailable to non-interactive remote commands, so
`ssh host 'mise-managed-tool …'` won't find those tools. Anything that must
survive into non-interactive sessions belongs in `~/.profile` /
`~/.profile.d/*.sh`; interactive-only setup stays in `~/.bashrc.d/`.

This is an acceptable trade-off because the common non-interactive path
(`rsync`/`scp`) is pure file transfer and needs no tooling. If the limitation
ever becomes a blocker — e.g. you routinely run `ssh host '<managed-tool> …'` —
drop the top-of-file guard and instead gate only the offenders per-script (the
`bind` calls in `30-atuin.sh`, the bare `where` at the end of `~/.bashrc`).
Tooling then loads non-interactively, at the cost of full startup on every
remote command and ongoing vigilance against new stdout offenders.

### chezmoi run scripts: re-establish PATH yourself

The same short-circuit hits chezmoi's `run_*` scripts under
`home/.chezmoiscripts/`: they execute as non-interactive shells and **never**
source `~/.bashrc.d/`, so tools installed by the bootstrap (`mise`, `brew`,
`nix`) are not on `PATH` just because the interactive config would put them
there. A script that calls such a tool without first putting it on `PATH` dies
with `command not found` — even though the tool is installed.

Each run script must therefore re-establish `PATH` itself, at the top, before
invoking the tool. To keep this uniform and in one place, the setup lives in
shared `.chezmoitemplates` partials, included with
<span v-pre>`{{ template "<name>" . }}`</span>:

- **`mise-shellenv`** — prepends `~/.local/bin` (the mise entry binary) and the
  mise shims dir. Include it in any script that calls `mise` directly, or a
  mise-managed tool directly (e.g. `pitchfork`). Note `mise run <task>` already
  exposes that task's managed tools, so for `mise run …` only the `mise` binary
  itself needs to be reachable.
- **`nix-profile`** — sources the OS-correct nix profile (macOS multi-user
  daemon vs Linux single-user), guarded so it is a no-op when nix is absent
  (safe under `set -e`).
- **`brew-shellenv`** — `eval`s `brew shellenv` for the OS/arch-correct prefix.

The interactive `~/.bashrc.d/` files (`10-nix`, `17-mise`, `08-homebrew`) use the
same partials, so interactive and non-interactive setup share one source of
truth. After installing a new bootstrap tool, add a partial for it and include
it in both the relevant run script and its `~/.bashrc.d/` file.

## Startup Caching

Shell startup caching is delegated to the tools themselves. Mise provides
built-in environment caching via `mise activate bash`, which caches environment
resolution at the module level and is the main lever for startup time, since
mise activation dominates the profile. See
[mise#7761](https://github.com/jdx/mise/pull/7761) for details.

A previous custom `_evalcache` helper cached the init/completion output of other
tools (zoxide, usage, zellij, carapace, Homebrew completion) to
`~/.cache/dotfiles/bash/`. It has been removed: those commands are single binary
invocations that generate their scripts in single-digit milliseconds, mise (the
actual startup bottleneck) now handles its own caching, and the helper had no
dependency-based invalidation, so its cache went stale silently on tool
upgrades.

## Shell completions

Completions come from several independent mechanisms, deliberately kept from
overlapping:

- **Distro `bash-completion` (Linux)** — the system framework at
  `/usr/share/bash-completion`, loaded once via `/etc/bash_completion`. It
  provides the lazy `complete -D` loader plus a large bundled library (~900
  command definitions).
- **Homebrew `bash-completion@2` (macOS only)** — macOS ships no system
  framework, so brew's is the engine there. Sourced from `08-homebrew.sh` and
  installed only on macOS (see `[bootstrap.packages]`).
- **carapace** — registers its own completions (`82-carapace.sh`), loaded
  after Homebrew so it wins for any command it also covers. Its spec library
  spans 1000+ commands.
- **mise and packslip tools** — `mise` emits its own completion
  (`17-mise.sh`) and, on every prompt, auto-registers completions for the
  packslip tools it manages, reading each vendor's script lazily on first Tab
  and version-matching it to the active version.

### Why Homebrew completion is macOS-only

The two `bash-completion` frameworks are the same software; at runtime they are
mutually exclusive — each self-guards on `BASH_COMPLETION_VERSINFO`, so the
first to load wins and the second is a no-op. Loading both is never wanted.

On Linux the distro framework already provides the loader and the bundled
library, lazily. Homebrew's `bash-completion@2` (v2) no longer ships that
bundled library at all; formulae that provide completions instead drop them as
eager files under `$HOMEBREW_PREFIX/etc/bash_completion.d`. Sourcing brew's
framework on Linux to pick those up would eagerly source ~150 files on every
shell start — the startup cost this setup exists to minimise — for completions
the distro framework and carapace already largely cover. So on Linux brew's
`bash-completion@2` is neither installed nor sourced; the sourcing in
`08-homebrew.sh` is gated to Darwin with chezmoi templating
(`{{ if eq .chezmoi.os "darwin" }}`), making the intent explicit rather than
relying on a path that happens to be absent.

On a minimal Linux distro that omits the system `bash-completion` package,
completions come only from mise, carapace and the Usage tools. Installing
brew's would not help — v2 carries no bundled library — so the fix there is to
install the distro's own `bash-completion` package.

### No per-tool completion hooks for auto-registered tools

Because mise auto-registers completions for its packslip tools, `usage` and
`fnox` need no completion line in their `bashrc.d` files — mise registers
(and, being a per-prompt hook, would immediately override) them regardless.
So the earlier `eval "$(usage --completions bash)"` and
`eval "$(fnox completion bash)"` lines were dropped as redundant.

Two related lines are deliberately kept, because mise does *not* cover them:

- `19-fnox.sh` keeps `eval "$(fnox activate bash)"` — that is environment
  activation, not completion.
- `21-aube.sh` keeps `eval "$(aube completion bash)"` — `aube`'s packslip
  declares no completion (`mise completion bash --tool aube` reports none), so
  mise registers nothing for it.
- `18-usage.sh` keeps `source <(usage generate completion-init bash)` — this
  registers a `complete -D` handler for standalone `usage`-shebang scripts on
  `PATH` (e.g. `~/.local/bin/pdftoepub`), a separate concern from the `usage`
  binary's own completion.

## Startup Profiling

Bash startup is instrumented so the time spent sourcing each
`~/.bashrc.d/*.sh` file can be measured, to identify bottlenecks. The
`profile_source` function in `~/.bashrc` times each sourced file when
`BASH_PROFILE_TIMING=1` is set.

### Usage

Profile startup and print the report in one step:

```bash
mise run bash:profile
```

This runs a login shell with `BASH_PROFILE_TIMING=1` set, in the current
directory, then processes the resulting timing log into the report below. Run
it from inside a project directory to measure startup as experienced there —
`mise` resolves that project's toolset, which is usually the dominant cost.

To process a log captured some other way — e.g. from a real interactive
session started with `BASH_PROFILE_TIMING=1 exec bash` — run the processing
step on its own:

```bash
mise run bash:profile-process
```

### Output

The report is produced by an awk pipeline over the timing log and printed as a
formatted summary with rankings and percentages.

Example output (illustrative — your numbers will differ by machine, run and
cache warmth; re-run the steps above to refresh):

```text
=== Bash Startup Timing Summary ===
Rank  Sourced File                                        Time (ms)   Relative   Cumulative
----- -----------------------------------------           ---------   --------  -----------
1     ~/.bashrc.d/17-mise.sh                                105.787     46.35%       46.35%
2     ~/.bashrc.d/27-chezmoi.sh                              28.827     12.63%       58.98%
3     ~/.bashrc.d/08-homebrew.sh                             25.396     11.13%       70.11%
4     ~/.bashrc.d/75-zellij.sh                               20.581      9.02%       79.13%
5     ~/.bashrc.d/19-fnox.sh                                  8.617      3.78%       82.90%
6     ~/.bashrc.d/82-carapace.sh                              5.556      2.43%       85.34%
7     ~/.bashrc.d/21-aube.sh                                  4.281      1.88%       87.21%
8     ~/.bashrc.d/18-usage.sh                                 4.119      1.80%       89.02%
9     /etc/bash_completion                                    3.818      1.67%       90.69%
10    ~/.bashrc.d/25-zoxide.sh                                2.281      1.00%       91.69%
11    ~/.bashrc.d/10-nix.sh                                   0.245      0.11%       91.80%
12    ~/.bashrc.d/35-functions.sh                             0.097      0.04%       91.84%
13    ~/.bashrc.d/55-task.sh                                  0.050      0.02%       91.86%
14    ~/.bashrc.d/45-julia.sh                                 0.025      0.01%       91.87%
15    ~/.bashrc.d/57-yazi.sh                                  0.024      0.01%       91.88%
16    ~/.bashrc.d/60-tmux.sh                                  0.022      0.01%       91.89%
17    ~/.bashrc.d/32-nvim.sh                                  0.021      0.01%       91.90%
      TOTAL SOURCED                                         209.747     91.90%       91.90%
      TOTAL                                                 228.228       100%         100%
```

The report makes it easy to spot the slowest contributors; `mise` activation
dominates (~46% here), which is why startup caching is left to mise itself.

### Notes

- Profiling only works with Bash 5+ (requires `$EPOCHREALTIME`)
- The timing log is overwritten at the start of each profiling session
- Log is stored at `~/.local/share/dotfiles/bash/profile_timing.log`
- Only files in `~/.bashrc.d/*.sh` and `/etc/bash_completion` are profiled
- Disable profiling by unsetting the variable: `unset BASH_PROFILE_TIMING`
- **Caveat**: Atuin files bypass profiling to preserve execution context.
  Atuin's bash-preexec hooks are extremely sensitive to execution context — even
  function wrappers change the call stack enough to break command recording

## Bash Configuration Files

The `~/.bashrc.d/` directory contains modular configuration files:

- Shell options and settings
- Tool integrations (mise, pitchfork, etc.)
- Aliases and functions
- Completion configurations

This modular approach makes it easy to manage and profile individual components
of the bash startup process.
