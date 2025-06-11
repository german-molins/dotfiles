# File Exploration Rules

## REQUIRED TOOLS

ALWAYS use these modern tools instead of their traditional counterparts:

- `fd` MUST be used instead of `find` for file discovery
- `rg` (ripgrep) MUST be used instead of `grep` for searching file contents

## Examples

Instead of:

```bash
find . -name "*.js"
grep "pattern" file.txt
```

Use:

```bash
fd ".js$"
rg "pattern" file.txt
```

These tools provide better performance, more intuitive syntax, and are the
required standard for this project.
