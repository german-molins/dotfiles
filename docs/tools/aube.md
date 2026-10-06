# aube

[aube](https://aube.sh) is a fast Node.js package manager that also reads npm
lockfiles. It is installed globally by mise (and builds these docs, see
[Development Guide](../dev_guide.md)), but on npm repositories I opt in per
repository and only locally, through `mise.local.toml`. See
[Worktree Workflow](../worktree_workflow.md) for the surrounding setup.

## Opting In

```toml
# mise.local.toml
[wrappers]
npm = "aube"

[env]
AUBE_NODE_LINKER = "hoisted"
AUBE_NO_AUTO_INSTALL = "true"
```

- [`[wrappers]`](https://mise.jdx.dev/dev-tools/shims.html#command-wrappers)
  routes every `npm` call through aube, so scripts, hooks and agents need no
  changes. Run `mise reshim` after adding it.
- **Hoisted linker**: npm projects expect a flat `node_modules`; aube's default
  is isolated ([hoisted mode](https://aube.sh/package-manager/node-modules.html#hoisted-mode),
  [`nodeLinker`](https://aube.sh/settings/#setting-nodelinker)).
- **No auto-install**: `aube run` installs first when the tree is stale
  ([scripts](https://aube.sh/package-manager/scripts.html#scripts)). When mise
  daemons or parallel tasks run several scripts at once, those installs race
  and corrupt `node_modules`, so turn it off
  ([`aubeNoAutoInstall`](https://aube.sh/settings/#setting-aubenoautoinstall))
  and install explicitly.
- **Builds**: dependency lifecycle scripts only run when allowed
  ([`allowBuilds`](https://aube.sh/settings/#setting-allowbuilds)). It lives in
  `package.json` or the workspace YAML, which are tracked; for a purely local
  setup, `AUBE_DANGEROUSLY_ALLOW_ALL_BUILDS=true`
  ([`dangerouslyAllowAllBuilds`](https://aube.sh/settings/#setting-dangerouslyallowallbuilds))
  restores npm's behaviour.

Packages are linked from aube's
[global store](https://aube.sh/package-manager/node-modules.html#global-store),
so each new worktree installs fast and shares disk.

## npm Repositories

aube installs from `package-lock.json` and keeps it as the source of truth
([for npm users](https://aube.sh/npm-users.html#for-npm-users),
[differences from npm](https://aube.sh/npm-users.html#differences-from-npm)).
What bit me:

- Add, remove or update dependencies with the real npm, bypassing the wrapper,
  so teammates get the lockfile npm would write:
  `"$(mise which npm)" install <pkg>`.
- Every workspace `package.json` needs a `version`.
- aube ignores `npm run --workspace <name>`; run the script from the
  workspace's directory instead.

## When Not Worth It

Measured on btrfs for a new worktree of a large monorepo:

| Setup | Time |
|-------|------|
| npm, fresh install | ~21 s |
| npm, `node_modules` reflink-copied from the primary | ~7 s |
| aube, fresh install | ~4.3 s |

On a reflink filesystem, copying `node_modules` with
[`.worktreeinclude`](worktrunk.md#copying-ignored-files) gets plain npm close
enough. Don't combine both: aube's `node_modules/.modules.yaml` stores the
source worktree's absolute path, so aube relinks everything anyway.
