# Setup

## Environment Variables

Environment variables that determine the templating environment:

| envvar | description | allowed values |
| --------------- | --------------- | --------------- |
| `DOTFILES_PROFILE` | Profile name | "personal", "quantica" |

### DevPod

Environment variables can be made available to `devpod` installation of
dotfiles by option `--dotfiles-script-env ENVVAR=VALUE...` or
`--dotfiles-script-env env_file...`. Example using default profile:

```sh
devpod up . --dotfiles-script-env DOTFILES_PROFILE=personal
```
