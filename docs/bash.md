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

The task generates two files:

- `timing.csv`: Raw timing data in CSV format (file,duration_ms)
- `summary.txt`: Formatted summary with rankings and percentages

### Example Output

After enabling profiling and running the commands, the output might look like this:

```bash
$ BASH_PROFILE_TIMING=1 exec bash
Bash profiling enabled. Log will be written to ~/.bash_profile_timing.log
host  : example-host
user  : user
shell : bash 5.3.3(1)-release
wd    : /home/user

$ mise run bash:profile
[bash:profile] $ ~/.config/mise/tasks/bash/profile
Processing bash startup timing log...
Generated timing.csv with 45 entries
Generated summary.txt

=== Bash Startup Timing Summary ===
Rank  Sourced File                                        Time (ms)   Relative   Cumulative
----- -----------------------------------------           ---------   --------  -----------
1     /Users/user/.bashrc.d/17-mise.sh                      568.093     34.73%       34.73%
2     /Users/user/.bashrc.d/15-devbox.sh                    293.092     17.92%       52.65%
3     /Users/user/.bashrc.d/40-homebrew.sh                   22.445      1.37%       54.02%
4     /Users/user/.bashrc.d/19-pixi.sh                       18.649      1.14%       55.16%
5     /Users/user/.bashrc.d/30-atuin.sh                      16.998      1.04%       56.20%
6     /Users/user/.bashrc.d/75-zellij.sh                     14.770      0.90%       57.10%
7     /Users/user/.bashrc.d/27-chezmoi.sh                    14.298      0.87%       57.97%
8     /Users/user/.bashrc.d/82-carapace.sh                    9.805      0.60%       58.57%
9     /Users/user/.bashrc.d/90-direnv.sh                      6.041      0.37%       58.94%
10    /Users/user/.bashrc.d/18-usage.sh                       4.509      0.28%       59.22%
11    /Users/user/.bashrc.d/25-zoxide.sh                      4.266      0.26%       59.48%
12    /Users/user/.bashrc.d/35-functions.sh                   0.089      0.01%       59.48%
13    /Users/user/.bashrc.d/55-task.sh                        0.078      0.00%       59.49%
14    /Users/user/.bashrc.d/05-cache.sh                       0.063      0.00%       59.49%
15    /Users/user/.bashrc.d/20-aliases.sh                     0.047      0.00%       59.50%
16    /Users/user/.bashrc.d/45-julia.sh                       0.040      0.00%       59.50%
17    /Users/user/.bashrc.d/10-nix.sh                         0.032      0.00%       59.50%
18    /Users/user/.bashrc.d/57-yazi.sh                        0.031      0.00%       59.50%
19    /Users/user/.bashrc.d/60-tmux.sh                        0.030      0.00%       59.50%
20    /Users/user/.bashrc.d/32-nvim.sh                        0.025      0.00%       59.51%
21    /Users/user/.bashrc.d/47-amazon-q.sh                    0.024      0.00%       59.51%
22    /Users/user/.bashrc.d/48-amazon-q_cargo.sh              0.020      0.00%       59.51%
23    /Users/user/.bashrc.d/50-aichat.sh                      0.018      0.00%       59.51%
24    /Users/user/.bashrc.d/52-jupyter.sh                     0.017      0.00%       59.51%
      TOTAL                                                1635.818      100%        100%
```

### Notes

- Profiling only works with Bash 5+ (requires `$EPOCHREALTIME`)
- The timing log is cleared each time profiling is enabled
- Only files in `~/.bashrc.d/*.sh` and `/etc/bash_completion` are profiled
- Disable profiling by unsetting the variable: `unset BASH_PROFILE_TIMING`

## Bash Configuration Files

The `~/.bashrc.d/` directory contains modular configuration files:

- Shell options and settings
- Tool integrations (mise, direnv, etc.)
- Aliases and functions
- Completion configurations

This modular approach makes it easy to manage and profile individual components
of the bash startup process.
