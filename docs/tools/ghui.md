# [ghui](https://github.com/kitlangton/ghui)

Terminal UI for GitHub pull requests. Installed from the upstream GitHub
releases via the `github:kitlangton/ghui` backend.

## Backend choice

The mise registry maps `ghui` to `npm:@kitlangton/ghui`, whose launcher execs a
per-platform prebuilt pulled through npm optional dependencies. That path was
dropped once: aube pinned a stale `~aube~<hash>` content hash the registry no
longer served, and the package sat below mise's download threshold, so it could
not lock or install cleanly.

The `github:` backend pulls the release tarball
(`ghui-linux-x64.tar.gz`) straight from GitHub, sidestepping both the npm/aube
layer and the download threshold, and extracts a ready-to-run `ghui` binary.

## Non-AVX2 note

ghui ships as a [Bun](https://bun.sh) `--compile` standalone. Historically the
`linux-x64` artifact used the default (haswell) target and required AVX2, so it
faulted with `Illegal instruction` (SIGILL) on x86_64 hosts without AVX2 — such
as the default `kvm64`/`qemu64` vCPU models of QEMU/Proxmox VMs — before any
code ran. That required a `postinstall` hook to rebuild the binary with the
`bun-linux-x64-baseline` target.

Current releases (verified on v0.9.1) run on non-AVX2 hosts directly: the
release `linux-x64` build no longer needs AVX2, so the rebuild hook is gone and
the tool is a plain `"github:kitlangton/ghui" = "latest"` entry. See
[hunkdiff](https://github.com/modem-dev/hunk), which had the same root cause and
the same resolution — a native release binary that runs baseline-safe.
