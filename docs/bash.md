# Bash Configuration

This dotfiles repository includes several bash-related configurations and tools.

## Bash Startup Files

The bash configuration is organized as follows:

- `~/.bashrc`: Main bash configuration file
- `~/.bashrc.d/*.sh`: Modular bash configuration files
- `~/.profile`: Login shell profile

## Bash Startup Profiling

This feature allows you to measure the startup time of individual files sourced during bash initialization to identify performance bottlenecks.

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

```
Rank  Sourced File                                     Time (ms)   Relative   Cumulative
----- -----------------------------------------         ---------   --------   -----------
1     /home/user/.bashrc.d/mise.sh                     150.321      42.18%       42.18%
2     /home/user/.bashrc.d/homebrew.sh                 120.874      33.90%       76.08%
3     /home/user/.bashrc.d/direnv.sh                    85.502      23.92%      100.00%
      TOTAL                                            356.697      100%        100%
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

This modular approach makes it easy to manage and profile individual components of the bash startup process.
