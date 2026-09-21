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

## Startup Profiling

Bash startup is instrumented so the time spent sourcing each
`~/.bashrc.d/*.sh` file can be measured, to identify bottlenecks. The
`profile_source` function in `~/.bashrc` times each sourced file when
`BASH_PROFILE_TIMING=1` is set.

### Usage

1. **Enable profiling** by setting the environment variable:

   ```bash
   export BASH_PROFILE_TIMING=1
   ```

2. **Start a new bash session** to generate the timing log:

   ```bash
   bash -l
   ```

3. **Process the timing data** using the mise task:

   ```bash
   mise run bash:profile
   ```

### Output

The task processes the timing data in a pipeline and prints a formatted summary
with rankings and percentages. No intermediate files are created.

Example output:

```text
=== Bash Startup Timing Summary ===
Rank  Sourced File                                        Time (ms)   Relative   Cumulative
----- -----------------------------------------           ---------   --------  -----------
1     ~/.bashrc.d/17-mise.sh                                627.363     51.65%       51.65%
2     ~/.bashrc.d/15-devbox.sh                              337.218     27.76%       79.41%
3     ~/.bashrc.d/27-chezmoi.sh                              66.921      5.51%       84.92%
4     ~/.bashrc.d/82-carapace.sh                             42.791      3.52%       88.44%
5     ~/.bashrc.d/30-atuin.sh                                19.015      1.57%       90.01%
6     ~/.bashrc.d/75-zellij.sh                               16.325      1.34%       91.35%
7     ~/.bashrc.d/25-zoxide.sh                                7.302      0.60%       91.95%
8     ~/.bashrc.d/18-usage.sh                                 4.817      0.40%       92.35%
      TOTAL                                                1214.708       100%         100%
```

The report makes it easy to spot the slowest contributors; `mise` activation
typically dominates.

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
