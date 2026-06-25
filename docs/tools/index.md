# Tools

## List Of Tools

### Main Tools And Apps

These are my daily CLI drivers:

| Name | Commands | Aliases | Description |
|------|---------|-------|-------------|
| [Chezmoi] | `chezmoi` | | Dotfiles manager |
| [Mise] | `mise` | | Global and project package manager |
| [UPT] | `upt` | `mise run upt` | Cross-platform system package manager|
| [Kitty] | `kitty` | | Terminal emulator |
| [Alacritty] | `alacritty` | | Terminal emulator |
| [Bash] | `bash` | | Interactive shell |
| [Usage] | `usage` | | Polyglot script CLI manager |
| [Fnox] | `fnox` | | Secret manager |
| [Zellij] | `zellij` | `z{e,r}{,f,i}` | Terminal workspaces |
| [Zoxide] | `zoxide` | `cd`, `cdi` | Smarter `cd` |
| [Atuin] | `atuin` | | Shell history manager |
| [Carapace] | `carapace` | | Shell completion |
| [Yazi] | `yazi`, `ya` | `y` | File manager |
| [Neovim] | `nvim` | | Text editor and IDE |
| [Chezit] | `chezit` | | Chezmoi TUI |
| [bottom] | `btm` | | System monitor |
| [Lazydocker] | `lazydocker` | | Docker and docker-compose manager |
| [Pitchfork] | `pitchfork` | | Daemons manager |
| [Taskwarrior] | `task` | | Task manager |
| [Timewarrior] | `timew` | | Time manager |
| [Zk] | `zk` | | Notebook manager |
| [Lnav] | `lnav` | | Logfile navigator |

[Chezmoi]: https://www.chezmoi.io/
[Mise]: https://mise.en.dev/
[UPT]: https://github.com/sigoden/upt
[Kitty]: https://sw.kovidgoyal.net/kitty/
[Alacritty]: https://alacritty.org/
[Bash]: https://devdocs.io/bash/
[Usage]: https://usage.jdx.dev/
[Fnox]: https://fnox.jdx.dev/
[Zellij]: https://zellij.dev/
[Zoxide]: https://github.com/ajeetdsouza/zoxide
[Atuin]: https://atuin.sh/
[Carapace]: https://carapace-sh.github.io/carapace-bin/
[Yazi]: https://yazi-rs.github.io/
[Neovim]: https://neovim.io/
[Chezit]: https://github.com/daptify14/chezit
[bottom]: https://github.com/ClementTsang/bottom
[Lazydocker]: https://github.com/jesseduffield/lazydocker
[Pitchfork]: https://pitchfork.en.dev/
[Taskwarrior]: https://taskwarrior.org/
[Timewarrior]: https://timewarrior.net/
[Zk]: https://zk-org.github.io/zk/
[Lnav]: https://lnav.org/

VCS:

| Name | Commands | Aliases | Description |
|------|---------|-------|-------------|
| [Git] | `git` | | Version control system |
| [Lazygit] | `lazygit` | `git ui` | Git manager |
| [GitHub CLI] | `gh` | | GitHub CLI |
| [GitHub Dashboard] | `gh-dash` | `gh dash` | Pull requests and issues manager |
| [Jujutsu] | `jj` | | Git-compatible VCS |
| [Jujutsu UI] | `jjui` | `jj ui` | Jujutsu manager |
| [Lazyjj] | `lazyjj` | | Jujutsu manager |

[Git]: https://git-scm.com/
[Lazygit]: https://github.com/jesseduffield/lazygit
[GitHub CLI]: https://cli.github.com/
[GitHub Dashboard]: https://www.gh-dash.dev
[Jujutsu]: https://docs.jj-vcs.dev
[Jujutsu UI]: https://idursun.github.io/jjui
[Lazyjj]: https://github.com/Cretezy/lazyjj

Agent harnesses:

| Name | Commands | Aliases | LLM Providers | API Keys |
|---|---|---|---|---|
| [Amp] | `amp` | | Amp subscription<br>Free mode (`/mode free`) | `AMP_API_KEY` |
| [Claude Code] | `claude` | | Anthropic subscription OAuth | |
| [Opencode] | `opencode` | `oc` | Opencode Zen<br>OpenRouter | `OPENCODE_API_KEY`<br>`OPENROUTER_API_KEY` |
| [Pi] | `pi` | | Anthropic subscription OAuth | |
| [Codebuff] | `codebuff` | | Free tier | |
| [Freebuff] | `freebuff` | | Free tier | |
| [Antigravity CLI] | `agy` | | Gemini free tier | Google OAuth |
| [Codex] | `codex` | | OpenAI free tier | OAuth |

[Amp]: https://ampcode.com/
[Claude Code]: https://code.claude.com
[Opencode]: https://opencode.ai
[Pi]: https://pi.dev/
[Codebuff]: https://www.codebuff.com
[Freebuff]: https://freebuff.com
[Antigravity CLI]: https://antigravity.google/product/antigravity-cli
[Codex]: https://developers.openai.com/codex

External LLM service providers:

- [OpenRouter](https://openrouter.ai)

### Basic Shell Tools

These modern tools offer a simple alternative to traditional Unix tools in most
common cases:

| Name | Command | Unix counterpart | Description |
|------|---------|-------|-------------|
| [bat] | `bat` | `cat` | Concatenate and paginate files |
| [fd] | `fd` | `find` | Find entries in filesystem |
| [ripgreg] | `rg` | `grep` | Search for pattern in files |
| [sd] | `sd` | `sed` | Find and replace patterns in files|

[bat]: https://github.com/sharkdp/bat
[fd]: https://github.com/sharkdp/fd
[ripgreg]: https://github.com/BurntSushi/ripgrep
[sd]: https://github.com/chmln/sd

### Other Tools

| Name | Commands | Aliases | Description |
|------|---------|-------|-------------|
| [Git Extras] | `git-extras` | `git extra`, [full list] | Extensive set of convenient Git subcommands |
| [LazySSH] | `lazyssh` | | SSH manager |
| [Trzsz-ssh] | `tssh` | | SSH client, drop-in replacement of [OpenSSH] |
| [mdnstool] | `mdnstool` | `mdns` | mDNS utility |
| [somo] | `somo` | | Socket and port monitoring |
| [cosign] | `cosign` | | Signing and verifying packages |
| [Numbat] | `numbat` | `num`, `calc` | Scientific calculator with physical units |
| [systemctl-tui] | `systemctl-tui` | | systemd TUI |
| [CodeBurn] | `codeburn` | | systemd TUI |

[Git Extras]: https://github.com/tj/git-extras
[full list]: https://github.com/tj/git-extras/blob/main/Commands.md
[LazySSH]: https://github.com/Adembc/lazyssh
[Trzsz-ssh]: https://trzsz.github.io/ssh
[OpenSSH]: https://www.openssh.com/
[mdnstool]: https://github.com/ghetzel/mdnstool
[somo]: https://github.com/theopfr/somo/
[cosign]: https://github.com/sigstore/cosign
[Numbat]: https://numbat.dev
[systemctl-tui]: https://github.com/rgwood/systemctl-tui
[CodeBurn]: https://codeburn.app

### Fallback Apps

The following apps are not installed by default but have configuration available:

| App | Installed | Configuration |
|-----|-----------|---------------|
| tmux | No | Yes |

### Virtualization

| Name | Commands | Aliases | Description |
|------|---------|-------|-------------|
| [Devpod] | `devpod` | | Devcontainer manager |
| [Colima] | `colima` | `vm` | Containers runtimes |

[Devpod]: https://devpod.sh/
[Colima]: https://colima.run

## Package Registries

Mise:

- [Mise registry](https://mise.jdx.dev/registry.html#tools)
- Aqua backend: [Aqua registry](https://aquaproj.github.io/docs/products/aqua-registry/)
- Cargo backend: [Crates](https://crates.io/)
- Pipx backend: [PyPI](https://pypi.org/)

Devbox:

- [NixHub](https://www.nixhub.io/)

Yazi:

- Official plugins: [Plugins](https://github.com/yazi-rs/plugins)
- Color schemes: [Flavors](https://github.com/yazi-rs/flavors)

## Sites Of Interest

- [Terminal Trove](https://terminaltrove.com/): Discover and share terminal tools
- [dotfyle](https://dotfyle.com/): Discover and share Neovim plugins
