# Bash Configuration

This dotfiles repository includes several bash-related configurations and tools.

## Bash Startup Files

The bash configuration is organized as follows:

- `~/.bashrc`: Main bash configuration file
- `~/.bashrc.d/*.sh`: Modular bash configuration files
- `~/.profile`: Login shell profile

## Bash Startup Profiling

This feature allows you to measure the startup time of individual files sourced
during bash initialization to identify performance bottlenecks.

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

The task processes the timing data in a pipeline and displays a formatted
summary with rankings and percentages. No intermediate files are created.

### Example Output

After enabling profiling and running the commands, the output might look like
this:

Without activation hooks caching:

```bash
$ BASH_PROFILE_TIMING=1 exec bash
Bash profiling enabled. Log will be written to ~/.local/share/dotfiles/bash/profile_timing.log
host  : example-host
user  : user
shell : bash 5.3.3(1)-release
wd    : /home/user

: mise run bash:profile
[bash:profile] $ ~/.config/mise/tasks/bash/profile
Processing bash startup timing log...

=== Bash Startup Timing Summary ===
Rank  Sourced File                                        Time (ms)   Relative   Cumulative
----- -----------------------------------------           ---------   --------  -----------
1     /Users/user/.bashrc.d/17-mise.sh                      627.363     51.65%       51.65%
2     /Users/user/.bashrc.d/15-devbox.sh                    337.218     27.76%       79.41%
3     /Users/user/.bashrc.d/27-chezmoi.sh                    66.921      5.51%       84.92%
4     /Users/user/.bashrc.d/82-carapace.sh                   42.791      3.52%       88.44%
5     /Users/user/.bashrc.d/19-pixi.sh                       42.516      3.50%       91.94%
6     /Users/user/.bashrc.d/40-homebrew.sh                   25.505      2.10%       94.04%
7     /Users/user/.bashrc.d/90-direnv.sh                     20.107      1.66%       95.70%
8     /Users/user/.bashrc.d/30-atuin.sh                      19.015      1.57%       97.26%
9     /Users/user/.bashrc.d/75-zellij.sh                     16.325      1.34%       98.60%
10    /Users/user/.bashrc.d/25-zoxide.sh                      7.302      0.60%       99.21%
11    /Users/user/.bashrc.d/18-usage.sh                       4.817      0.40%       99.60%
12    /Users/user/.bashrc.d/32-nvim.sh                        0.328      0.03%       99.63%
13    /Users/user/.bashrc.d/35-functions.sh                   0.309      0.03%       99.65%
14    /Users/user/.bashrc.d/05-cache.sh                       0.272      0.02%       99.68%
15    /Users/user/.bashrc.d/20-aliases.sh                     0.197      0.02%       99.69%
16    /Users/user/.bashrc.d/60-tmux.sh                        0.180      0.01%       99.71%
17    /Users/user/.bashrc.d/10-nix.sh                         0.170      0.01%       99.72%
18    /Users/user/.bashrc.d/47-amazon-q.sh                    0.168      0.01%       99.74%
19    /Users/user/.bashrc.d/45-julia.sh                       0.164      0.01%       99.75%
20    /Users/user/.bashrc.d/55-task.sh                        0.139      0.01%       99.76%
21    /Users/user/.bashrc.d/48-amazon-q_cargo.sh              0.134      0.01%       99.77%
22    /Users/user/.bashrc.d/50-aichat.sh                      0.109      0.01%       99.78%
23    /Users/user/.bashrc.d/57-yazi.sh                        0.063      0.01%       99.79%
24    /Users/user/.bashrc.d/52-jupyter.sh                     0.044      0.00%       99.79%
      TOTAL SOURCED                                        1212.157     99.79%       99.79%
      TOTAL                                                1214.708       100%         100%
```

With caching (60% faster):

```bash
=== Bash Startup Timing Summary ===
Rank  Sourced File                                        Time (ms)   Relative   Cumulative
----- -----------------------------------------           ---------   --------  -----------
1     /Users/user/.bashrc.d/17-mise.sh                      101.585     21.02%       21.02%
2     /Users/user/.bashrc.d/40-homebrew.sh                   58.143     12.03%       33.05%
3     /Users/user/.bashrc.d/15-devbox.sh                     50.943     10.54%       43.59%
4     /Users/user/.bashrc.d/30-atuin.sh                      47.790      9.89%       53.48%
5     /Users/user/.bashrc.d/90-direnv.sh                     39.156      8.10%       61.58%
6     /Users/user/.bashrc.d/25-zoxide.sh                     38.471      7.96%       69.54%
7     /Users/user/.bashrc.d/18-usage.sh                      37.715      7.80%       77.34%
8     /Users/user/.bashrc.d/75-zellij.sh                     37.555      7.77%       85.11%
9     /Users/user/.bashrc.d/82-carapace.sh                   35.852      7.42%       92.53%
10    /Users/user/.bashrc.d/19-pixi.sh                       18.856      3.90%       96.43%
11    /Users/user/.bashrc.d/27-chezmoi.sh                    14.085      2.91%       99.35%
12    /Users/user/.bashrc.d/35-functions.sh                   0.098      0.02%       99.37%
13    /Users/user/.bashrc.d/05-cache.sh                       0.068      0.01%       99.38%
14    /Users/user/.bashrc.d/55-task.sh                        0.067      0.01%       99.40%
15    /Users/user/.bashrc.d/45-julia.sh                       0.053      0.01%       99.41%
16    /Users/user/.bashrc.d/20-aliases.sh                     0.048      0.01%       99.42%
17    /Users/user/.bashrc.d/10-nix.sh                         0.032      0.01%       99.42%
18    /Users/user/.bashrc.d/57-yazi.sh                        0.030      0.01%       99.43%
19    /Users/user/.bashrc.d/60-tmux.sh                        0.030      0.01%       99.44%
20    /Users/user/.bashrc.d/47-amazon-q.sh                    0.028      0.01%       99.44%
21    /Users/user/.bashrc.d/32-nvim.sh                        0.025      0.01%       99.45%
22    /Users/user/.bashrc.d/50-aichat.sh                      0.021      0.00%       99.45%
23    /Users/user/.bashrc.d/48-amazon-q_cargo.sh              0.020      0.00%       99.46%
24    /Users/user/.bashrc.d/52-jupyter.sh                     0.017      0.00%       99.46%
      TOTAL SOURCED                                         480.688     99.46%       99.46%
      TOTAL                                                 483.298       100%         100%
```

### Notes

- Profiling only works with Bash 5+ (requires `$EPOCHREALTIME`)
- The timing log is overwritten at the start of each profiling session
- Log is stored at `~/.local/share/dotfiles/bash/profile_timing.log`
- Only files in `~/.bashrc.d/*.sh` and `/etc/bash_completion` are profiled
- Disable profiling by unsetting the variable: `unset BASH_PROFILE_TIMING`
- **Caveat**: Atuin files bypass profiling to preserve execution context.
Atuin's bash-preexec hooks are extremely sensitive to execution context - even
function wrappers change the call stack enough to break command recording

### Activation Hook Caching

To improve startup performance, mise activation hooks are cached. The cache is
automatically refreshed when:

- The mise binary (`~/.local/bin/mise`) is updated
- Tool installations change (`~/.local/share/mise/installs` directory timestamp)
- Project configuration changes (`mise.toml` in current directory)

**Limitations**: The cache may not refresh for all configuration changes (e.g.,
global config modifications, environment-specific configs). If activation hooks
seem stale, manually clear the cache:

```bash
mise run bash:clean
```

This removes all cached activation hooks and forces regeneration on next shell
startup.

## Bash Configuration Files

The `~/.bashrc.d/` directory contains modular configuration files:

- Shell options and settings
- Tool integrations (mise, direnv, etc.)
- Aliases and functions
- Completion configurations

This modular approach makes it easy to manage and profile individual components
of the bash startup process.
