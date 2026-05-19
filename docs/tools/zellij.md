# Zellij

## Layouts

- `dev`: Standard layout for git project development. Multi-instance.
- `dotfiles`: Extends `dev` with leading `chezmoi` tab running `chezit`. For
  editing this dotfiles repo.
- `home`: User central session for note-taking and system monitoring.
  Single-instance.

## Composition pattern

Zellij has no native layout includes, so shared blocks live in
`home/.chezmoitemplates/` and are inlined by chezmoi at apply time.

### Partials

- `zellij-default-tab.kdl`: `default_tab_template` block (tab-bar + status-bar
  panes). **All new layouts must include this partial** to keep the chrome
  consistent.
- `zellij-dev-tabs.kdl`: dev tab set (`vcs`, `edit`, `ai`, `services`). Reused
  by `dev` and `dotfiles`.

### Authoring a new layout

1. Create `home/dot_config/zellij/layouts/<name>.kdl.tmpl`.
2. Open with `layout {`, inline `zellij-default-tab.kdl`, add tabs (custom or
   via existing partials), close.

Example:

```kdl
layout {
  {{ template "zellij-default-tab.kdl" . }}

  tab name="custom" focus=true {
    pane { command "..." }
  }

  {{ template "zellij-dev-tabs.kdl" . }}
}
```

Tab order in the file = tab order in the bar. Use `focus=true` on the tab that
should open active.

### Why partials over a single base layout

Zellij parses each layout file standalone; no `include` directive exists.
Chezmoi templates render the partials before zellij ever reads the kdl, so the
runtime sees a flat, valid layout.
