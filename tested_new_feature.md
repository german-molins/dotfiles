With `DOTFILES_DEVBOX_ENABLED=false`, the result was:

```
: BASH_PROFILE_TIMING=1 exec bash
Bash profiling enabled. Log will be written to ~/.bash_profile_timing.log
host  : Q-HX332HQ2LF
user  : user
shell : bash 5.3.3(1)-release
wd    : /Users/user

: mise run bash:profile
[bash:profile] $ ~/.config/mise/tasks/bash/profile
Processing bash startup timing log...
Generated timing.csv with       21 entries
Generated summary.txt

=== Bash Startup Timing Summary ===
Rank  Sourced File                                        Time (ms)   Relative   Cumulative
----- -----------------------------------------           ---------   --------  -----------
1     /Users/user/.bashrc.d/17-mise.sh                      556.589     84.03%       84.03%
2     /Users/user/.bashrc.d/40-homebrew.sh                   23.114      3.49%       87.52%
3     /Users/user/.bashrc.d/19-pixi.sh                       18.727      2.83%       90.35%
4     /Users/user/.bashrc.d/30-atuin.sh                      17.412      2.63%       92.98%
5     /Users/user/.bashrc.d/75-zellij.sh                     15.539      2.35%       95.33%
6     /Users/user/.bashrc.d/27-chezmoi.sh                    13.462      2.03%       97.36%
7     /Users/user/.bashrc.d/82-carapace.sh                    8.637      1.30%       98.66%
8     /Users/user/.bashrc.d/18-usage.sh                       4.245      0.64%       99.30%
9     /Users/user/.bashrc.d/25-zoxide.sh                      3.918      0.59%       99.90%
10    /Users/user/.bashrc.d/48-amazon-q_cargo.sh              0.175      0.03%       99.92%
11    /Users/user/.bashrc.d/55-task.sh                        0.097      0.01%       99.94%
12    /Users/user/.bashrc.d/35-functions.sh                   0.087      0.01%       99.95%
13    /Users/user/.bashrc.d/45-julia.sh                       0.063      0.01%       99.96%
14    /Users/user/.bashrc.d/20-aliases.sh                     0.041      0.01%       99.96%
15    /Users/user/.bashrc.d/57-yazi.sh                        0.040      0.01%       99.97%
16    /Users/user/.bashrc.d/60-tmux.sh                        0.039      0.01%       99.98%
17    /Users/user/.bashrc.d/47-amazon-q.sh                    0.033      0.00%       99.98%
18    /Users/user/.bashrc.d/50-aichat.sh                      0.033      0.00%       99.99%
19    /Users/user/.bashrc.d/10-nix.sh                         0.032      0.00%       99.99%
20    /Users/user/.bashrc.d/52-jupyter.sh                     0.031      0.00%      100.00%
21    /Users/user/.bashrc.d/32-nvim.sh                        0.024      0.00%      100.00%
      TOTAL                                                 662.338      100%        100%
```
