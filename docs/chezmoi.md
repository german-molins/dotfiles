# Chezmoi

[Chezmoi](https://www.chezmoi.io/) is the dotfile manager used to declare, template, and apply all configuration files in this repository.

## Cross-Platform Config with Shared Templates

Some tools store their configuration in different paths depending on the OS:

| OS    | Config path                                  |
|-------|----------------------------------------------|
| macOS | `~/Library/Application Support/<tool>/`       |
| Linux | `~/.config/<tool>/`                           |

When both platforms need the **same config content**, use chezmoi's
`.chezmoitemplates/` directory to define the content once, then include it from
thin wrapper templates in each platform-specific path.

### Pattern overview

```
home/
├── .chezmoitemplates/
│   └── <tool>_config.yaml.tmpl        # ① Shared template (single source of truth)
├── .chezmoiignore.tmpl                # ② OS-conditional ignores
├── dot_config/<tool>/
│   └── config.yaml.tmpl              # ③ Linux wrapper  → includes ①
└── Library/Application Support/<tool>/
    └── config.yaml.tmpl              # ③ macOS wrapper  → includes ①
```

### Step-by-step example

The example below shows a hypothetical tool **mytool** whose config lives at
`~/.config/mytool/config.yaml` on Linux and
`~/Library/Application Support/mytool/config.yaml` on macOS.

#### ① Create the shared template

Place the actual config content in `.chezmoitemplates/`. The filename
(without `.tmpl`) becomes the template name used by `{{ template }}`.

```yaml
# home/.chezmoitemplates/mytool_config.yaml.tmpl

{{ if eq .profile "personal" -}}
theme: catppuccin
{{ else if eq .profile "work" -}}
theme: tokyonight
{{- end }}

settings:
  editor: nvim
  auto_update: true
```

#### ② Add OS-conditional ignores

In `.chezmoiignore.tmpl`, ignore each platform directory on the *other* OS so
chezmoi never tries to create `~/Library/` on Linux or `~/.config/mytool/` on
macOS (when the tool doesn't also use that path on macOS).

```text
# home/.chezmoiignore.tmpl

{{ if ne .chezmoi.os "darwin" -}}
Library/
{{ end -}}
{{ if ne .chezmoi.os "linux" -}}
.config/mytool/
{{ end -}}
```

#### ③ Create thin wrapper templates

Each platform path contains a one-line template that delegates to the shared
template.

**Linux** — `home/dot_config/mytool/config.yaml.tmpl`

```text
{{- template "mytool_config.yaml.tmpl" . -}}
```

**macOS** — `home/Library/Application Support/mytool/config.yaml.tmpl`

```text
{{- template "mytool_config.yaml.tmpl" . -}}
```

> **Note:** The wrapper passes `.` (the full template data context) so the
> shared template can access `.chezmoi`, `.profile`, and any other chezmoi
> data variables.

### Why this works

- **Single source of truth** — config content is authored once in
  `.chezmoitemplates/`.
- **No duplication** — wrapper files are one-liners.
- **OS isolation** — `.chezmoiignore.tmpl` ensures each OS only sees its own
  path, so `chezmoi apply` never creates wrong directories.
- **Full template power** — the shared template can use any Go template logic,
  sprig functions, and chezmoi data variables.
