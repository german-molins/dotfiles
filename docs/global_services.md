# Global Services

User-level daemons that start on login, managed by
[Pitchfork](https://pitchfork.jdx.dev/).

## Configuration

Services are defined in `~/.config/pitchfork/config.toml`. Each
`[daemons.<name>]` section declares a service in the `global` namespace.

Set `boot_start = true` for services that should start automatically on login.

## Bootstrap

The chezmoi script `run_onchange_after_15-enable-pitchfork-boot.sh.tmpl`
enables boot and starts the supervisor on first apply.
