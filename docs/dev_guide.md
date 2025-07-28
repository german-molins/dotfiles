# Development Guide

## Documentation

Stack used to build this static site:

- Framework: [VitePress](https://vitepress.dev/)
- Build runtime: [Bun](https://bun.com/)

## Devpod

A typical end-to-end testing or debugging command can look like

```sh
devpod up . --dotfiles-script-env-file ~/.dotfiles.env --reset --dotfiles-script-env DOTFILES_APPLY=false,DOTFILES_GIT_BRANCH=dev
```

## Devbox

For adding packages that are not available on a specific platform (OS and
arch), or if you just want to add it only on a set of platforms, use options

- `-e, --exclude-platform platform_1,platform_2,...`
- `-p, --platform platform_1,platform_2,...`

**Example**: Package `git-graph` is only available on Linux, so do either of
the equivalent

```sh
devbox global add git-graph --platform aarch64-linux,x86_64-linux
```

or

```sh
devbox global add git-graph --exclude-platform aarch64-darwin,x86_64-darwin
```
