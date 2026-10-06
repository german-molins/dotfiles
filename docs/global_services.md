# Global Services

User-level daemons that start on login, managed by
[Pitchfork](https://pitchfork.jdx.dev/).

## Configuration

Services are defined in `~/.config/pitchfork/config.toml`. Each
`[daemons.<name>]` section declares a service in the `global` namespace.

Set `boot_start = true` for services that should start automatically on login.

The file is shared with mise: `mise daemons` registers every project checkout
as a `[namespaces.<name>]` entry and pitchfork rewrites the whole file in its
own format, dropping comments and `description` keys. So chezmoi manages it
with the `modify_config.toml` template, which renders the daemons and settings
above and keeps whatever `[namespaces.*]` entries the file already has. Write
those sections the way pitchfork serializes them, or `chezmoi status` shows a
cosmetic diff after every pitchfork write. `mise daemons prune` leaves the
entries of deleted checkouts behind; remove them by hand.

## Cron Jobs

Scheduled tasks are regular daemons with a `cron` field. The schedule
uses **6-field** cron syntax:

- second
- minute
- hour
- day-of-month
- month
- day-of-week

The `retrigger` field controls re-execution behaviour when the schedule fires
again:

| Value       | Behaviour                                      |
|-------------|-------------------------------------------------|
| `"finish"`  | Retrigger after the previous run completes (default) |
| `"always"`  | Trigger every time the schedule fires            |
| `"success"` | Only retrigger if the previous run succeeded     |
| `"fail"`    | Only retrigger if the previous run failed        |

Output goes to `pitchfork logs <name>`.

## Bootstrap

The chezmoi script `run_onchange_after_15-enable-pitchfork-boot.sh.tmpl`
enables boot and starts the supervisor on first apply.
