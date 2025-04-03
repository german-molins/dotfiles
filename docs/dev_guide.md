# Development Guide

A typical end-to-end testing or debugging command can look like

```sh
devpod up . --dotfiles-script-env-file ~/.dotfiles.env --reset --dotfiles-script-env DOTFILES_APPLY=false,DOTFILES_GIT_BRANCH=dev
```
