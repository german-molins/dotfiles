# Playwright CLI

[Playwright CLI](https://github.com/microsoft/playwright-cli) (`playwright-cli`)
lets coding agents drive a headless browser: open a page, click through it,
read its accessibility snapshot and take screenshots. It is how agents check a
web UI change in the running app instead of only in tests.

## Stack

```text
agent ──shell──▶ playwright-cli ──DevTools protocol──▶ Chromium (headless) ──HTTP──▶ web app
        (skill teaches the commands)                    loads, runs and renders the page
```

- **Chromium** is the browser itself. It loads the page, runs its JavaScript
and renders it. Headless means it renders off-screen with no window, so it
works on a machine without a display, e.g. over SSH.
- **Playwright** launches Chromium and controls it through the Chrome DevTools
Protocol. `playwright-cli` wraps it in short commands for agents
(`playwright-cli open <url>`, `click e15`, `screenshot`). Browser sessions
persist between commands, and snapshots and screenshots are written to files
rather than into the agent's context.
- **The `playwright-cli` skill** teaches agents the commands. It costs no
context until browser work comes up.

## Setup

| Piece | Managed by | Where |
|-------|-----------|-------|
| `playwright-cli` | Global mise tool `npm:@playwright/cli`, lazy | `home/dot_config/mise/config.toml`, `mise.lock` and its `locks/npm-playwright-cli/` sidecar |
| `playwright-cli` skill | [Skills](../agents.md#skills-by-vercel) CLI, global | `home/dot_agents/dot_skill-lock.json` (the skill itself is not committed) |
| Chromium | `playwright-cli install-browser` | `run_onchange_after_30-install-playwright-browser.sh.tmpl` |
| CLI config | chezmoi | `home/dot_playwright/cli.config.json` (`~/.playwright/cli.config.json`) |
| Output dirs | Global gitignore | `.playwright/` and `.playwright-cli/` in `home/dot_gitignore` |

`playwright-cli` is not in the mise registry (its `playwright` entry is the
library, without the agent CLI), so it uses the npm backend.

The skill was installed for every agent in the lockfile's `lastSelectedAgents`,
only the `playwright-cli` skill of the repository (not its `dev` skill):

```sh
skills add microsoft/playwright-cli -g -s playwright-cli \
    -a amp cline codex cursor droid gemini-cli kilo kimi-code-cli opencode warp zed claude-code -y
```

With no config, `playwright-cli` launches Google Chrome (`chrome` channel,
`/opt/google/chrome/chrome`), not the Chromium that Playwright downloads, and
`open` fails where Chrome is not installed. The global config sets the
`chromium` channel so it uses the downloaded build; the other defaults
(headless, in-memory profile) fit.

Settings are merged in this order, later winning: the global
`~/.playwright/cli.config.json`, a project's `.playwright/cli.config.json`,
`PLAYWRIGHT_MCP_*` environment variables (e.g. `PLAYWRIGHT_MCP_BROWSER`), and
command-line flags (e.g. `--browser`).

## Browser Download

Each `playwright-cli` release is built against one Chromium version and
downloads that exact build into `~/.cache/ms-playwright/`, so the browser
always matches the CLI. It does not download a missing browser on demand:
without it, `playwright-cli open` fails with `Browser "chromium" is not
installed`.

The chezmoi script runs `playwright-cli install-browser chromium --no-shell`.
It is keyed on the locked `playwright-cli` version, so it runs on a fresh
machine and again only when the CLI is upgraded. When the browser is already
installed it is a no-op (under a second). Playwright deletes browser versions
that no installed Playwright uses anymore, so upgrades don't pile up.

Download cost per Chromium version (Chrome for Testing 155, linux-x64):

| Install | Download | At 100 Mbit/s | On disk |
|---------|----------|---------------|---------|
| `chromium --no-shell` (used) | 191 MiB: Chromium 189 + FFmpeg 2 | ~16 s | ~400 MB |
| `chromium --only-shell` | 120 MiB: headless shell 118 + FFmpeg 2 | ~10 s | ~270 MB |
| `chromium` (no flag) | 309 MiB: both builds + FFmpeg | ~26 s | |

FFmpeg is only used for recording videos. The headless shell is not
downloaded by default because the CLI launches full Chromium unless a config
says otherwise.

### Alternatives

- **Headless shell only** (`install-browser chromium --only-shell`): Chromium's
stripped-down automation build, 71 MiB smaller to download. The CLI must be
told to use it by setting the channel to `chromium-headless-shell` in the
global config.
- **mise `chrome-headless-shell`**: install Chrome for Testing's headless shell
as a lazy mise tool (`http:` backend) and point the global config's
`launchOptions.executablePath` at it. It downloads on first use and needs no
chezmoi script, but its version is pinned separately from the CLI's and must
be kept compatible by hand.

## Headless Servers

Neither build needs a display: Chromium runs with its own headless backend
(`--ozone-platform=headless`), with no X11 or Wayland session, e.g. over SSH.
Both still link against desktop shared libraries (NSS, ATK, X11 client
libraries, ALSA, libgbm, and for full Chromium also GTK, CUPS, Cairo and
Pango). A desktop install has them; a minimal server may not, and Chromium
then fails to start with a missing `.so` error. The headless shell needs fewer
of them but not none, so it does not avoid the problem.

On such a machine install them once with `playwright-cli install-browser
--with-deps chromium` (uses `apt` and needs sudo) or through the system
package manager. The chezmoi script leaves it out to keep `chezmoi apply`
unattended. Check with `ldd
~/.cache/ms-playwright/chromium-*/chrome-linux64/chrome | grep "not found"`.

## Sandbox

Chromium normally runs each web page in a locked-down process (the sandbox),
so a malicious site that exploits a browser bug still cannot reach the user's
files. Building it requires unprivileged user namespaces, which Ubuntu 23.10+
blocks through AppArmor for binaries without a profile, such as a downloaded
Chromium. Chromium then aborts with `No usable sandbox!`.

Playwright launches Chromium with `--no-sandbox` by default, so it works
without system changes: no `kernel.apparmor_restrict_unprivileged_userns`
sysctl and no AppArmor profile, neither of which fits in dotfiles. The cost is
that pages are not isolated from the user account. That is fine for an agent
testing your own apps on localhost or the LAN; avoid pointing it at untrusted
sites.

## Why Not MCP Or A Plugin

Playwright also ships an MCP server (`@playwright/mcp`), and the official
Claude Code `playwright` plugin bundles only that server, with no CLI or
skill. Playwright recommends the CLI for coding agents: an MCP server loads
its tool schemas into every session and returns page state into the context,
while the CLI with a skill costs nothing until used and works with any agent
that has a shell. This matches the [MCP servers](../agents.md#mcp-servers)
policy.
