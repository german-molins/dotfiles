# [ghui](https://github.com/kitlangton/ghui)

Terminal UI for GitHub pull requests. Installed via the npm backend as
`npm:@kitlangton/ghui`.

## Non-AVX2 build

ghui ships as a [Bun](https://bun.sh) standalone binary compiled with the
default `--compile` target (`bun-linux-x64`), which is the modern/haswell build
and requires AVX2. On x86_64 hosts without AVX2 — such as the default
`kvm64`/`qemu64` vCPU models of QEMU/Proxmox VMs — it faults immediately with
`Illegal instruction (core dumped)` (SIGILL), before any code runs.

This is the general behavior of `bun build --compile`: the default target bakes
the AVX2 runtime into the binary regardless of the build host, and only the
`-baseline` target variant produces an AVX2-free binary. Bun's own installer
detects a non-AVX2 host and fetches the baseline runtime, so the locally
installed `bun` runs fine; the break is only in the pre-compiled artifact.

[hunkdiff](https://github.com/modem-dev/hunk) has the same root cause, but it
falls back to a bundled baseline runtime when its prebuilt is removed. ghui
publishes no such fallback: its npm launcher only execs the per-platform
prebuilt, and the published package ships no source to run from. So the fix is
to rebuild the binary with the baseline target and swap it in place.

### Workaround

A `postinstall` hook on the mise tool entry, gated to non-AVX2 x86 hosts,
rebuilds the standalone binary from the matching source tag with the baseline
Bun target and overwrites the crashing prebuilt:

```sh
bun build --compile --bytecode --format=esm \
  --target=bun-linux-x64-baseline \
  --outfile="$bin" src/standalone.ts
```

On AVX2 hosts and non-x86 arches the hook is a no-op and the published prebuilt
is used unchanged. The hook reruns on every version bump, so `mise up` stays
fully managed. The only added cost, on the non-AVX2 host, is the rebuild
(~3 s: shallow clone + `bun install` + compile); runtime is identical to the
prebuilt.
