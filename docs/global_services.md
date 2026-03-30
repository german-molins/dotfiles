# Global Services

User-level daemons that start on login, managed by
[Pitchfork](https://pitchfork.jdx.dev/).

## Configuration

Services are defined in `~/.config/pitchfork/config.toml`. Each
`[daemons.<name>]` section declares a service in the `global` namespace.

Set `boot_start = true` for services that should start automatically on login.

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
