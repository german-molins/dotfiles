# Rust Build Workflow

Rust/Cargo builds here are cached and worktree-shared through
**[mr-boxington](https://mr-boxington.jdx.dev/)** (`mbx`), a Cargo-tailored
build cache. It replaces the previous [sccache](https://github.com/mozilla/sccache)
setup (see [Migrating from sccache](#migrating-from-sccache)).

`mbx` is installed as a global Mise tool and wired into Cargo through a Mise
**command wrapper**, so nothing about how you run Cargo changes — `cargo build`,
`cargo test`, `cargo run` all route through `mbx` transparently.

## How it is wired

`mbx` is a global Mise tool, wired into Cargo through a
[`[wrappers.cargo]`](https://mise.jdx.dev/configuration.html) block in the
global Mise config (`~/.config/mise/config.toml`). The wrapper makes Mise shim
`cargo` through `mbx` — instead of setting `RUSTC_WRAPPER` (the sccache
mechanism) — and `mbx` shims `rustc`/`rustdoc` under the hood. Command wrappers
need Mise ≥ 2026.9.2.

## What mbx does

`mbx` caches at two layers ([how it works](https://mr-boxington.jdx.dev/how-it-works)):

- **Compiler actions** — each `rustc`/`rustdoc`/`cc` invocation is
  content-hashed and its output stored in a shared, content-addressed store
  (`~/.cache/mbx`). Identical work anywhere on the machine is served from cache.
- **[Managed target directories](https://mr-boxington.jdx.dev/managed-targets)**
  — `mbx` replaces each checkout's `target/` with a symlink into the store and
  populates it with **reflink** (copy-on-write) clones. So multiple worktrees of
  the same repo share `target/` bytes on disk instead of each carrying a full
  1+ GiB copy.

Managed targets are garbage-collected automatically: when a checkout is removed,
after 30 days unused, or when the store exceeds its budget.

### Cross-worktree reuse

The payoff for a multi-worktree workflow: building a *fresh* checkout of a repo
already built elsewhere restores almost everything from cache. In benchmarking
(below), a second worktree built in 18s at **97.7% cache hits** — the compiler
never re-ran for the shared crates, and the shared `target/` cost near-zero
extra disk.

The handful of misses per worktree are per-checkout build scripts (e.g.
`serde`, `bindgen`) whose `OUT_DIR` is worktree-specific — expected, not a
regression.

### Incremental

`mbx` disables per-member Cargo incremental by default (its own
`incremental = false`), keeping every artifact cacheable and shareable. This
makes a manual `CARGO_INCREMENTAL = "0"` redundant under `mbx`.

## Linker: system

`mbx` can manage the linker
([managed linkers](https://mr-boxington.jdx.dev/linkers)), but every managed
selector — `rust-lld`/`lld` (bundled LLD, no download), `mold@ver`, `wild@ver`
(GitHub download) — requires **clang** on `PATH` as the driver. `rust-lld`
avoids the *download* but still needs clang. clang is not installed here, so all
managed linkers fail with `linker 'clang' not found`.

We therefore use `mbx`'s default **`system`** linker, which preserves Cargo's
own linker and adds **zero dependencies**. The `mbx` config
(`~/.config/mbx/config.toml`, tracked but empty) is the anchor for future linker
tuning; installing clang + a fast linker is tracked as a follow-up.

Override for one build without touching config:

```sh
MBX_LINKER=rust-lld cargo build   # needs clang on PATH
```

## Verify

```sh
mbx doctor              # confirm the cargo wrapper + shims are active
cargo build             # runs through mbx via the Mise wrapper
mbx explain --last      # cache hits/misses for the last build
mbx cache stats         # store size, managed targets, learned state
mbx gc --dry-run        # preview cleanup under the budgets
```

A build prints a summary line such as:

```
mbx[cache]: 256 hits, 6 misses, 4 not looked up, 4 bypassed; … stored locally
```

`not looked up` is first-population (nothing to restore yet); `bypassed` is work
`mbx` does not cache (e.g. link steps).

## Migrating from sccache

sccache is a generic compiler cache (Rust, C/C++, CUDA, distributed CI backends).
`mbx` is Rust/Cargo-only and worktree-aware. For a single-machine, many-worktree
local workflow the trade favors `mbx`; the one sccache edge that does not carry
over is its **distributed/remote cache** (S3/redis/…), a CI feature unused here.

### Mechanisms

| | **sccache** | **mr-boxington (mbx)** |
|---|---|---|
| Scope | Generic (Rust, C/C++, CUDA, distributed) | Rust/Cargo only, worktree-tailored |
| Unit cached | Individual `rustc`/`cc` invocations, content-hashed | Same, **plus manages `target/` itself** |
| `target/` | Untouched — each checkout keeps a full copy | Symlink into a content-addressed store; per-worktree dirs are **reflinks** (CoW) |
| Cross-worktree | Compiler cache is content-keyed → hits | Hits **and** shares `target/` disk via reflink |
| Cargo integration | `RUSTC_WRAPPER` env | Mise `[wrappers.cargo]` → `mbx` shim |
| Extra deps | none | none (with `system` linker) |
| Remote/distributed cache | ✓ S3/redis/memcached/gcs | ✗ local reflink store only |

### Measured

Benchmarked against a real private Rust workspace ("example repo"), single run
each, same commit:

| Scenario | sccache | mbx |
|---|---:|---:|
| Cold (empty cache) | 64s | 55s |
| Warm (`cargo clean`, keep cache, same checkout) | 23s | 0.14s |
| Fresh worktree (cross-worktree reuse) | ~23s\* | 18s (256 hits / 6 miss, 97.7%) |
| Cache store size | 143 MiB | 3.0 GiB |
| `target/` per worktree on disk | 1.1 GiB (duplicated ×N) | 1.2 GiB (reflink, ~shared) |

\* sccache's content-keyed cache hits similarly on a new checkout; not separately timed.

**Disk crossover.** Per-worktree cost is `sccache: 143M + N×1.1G` vs
`mbx: 3.0G + N×~reflink`. They break even near 3 worktrees; above that `mbx`
wins and the gap widens with each worktree. `mbx` also collapses the warm inner
loop to sub-second because its managed target is durable across `cargo clean`.

### Trade-offs

`mbx` is younger and Rust-specific: a larger absolute store (gc-managed), a few
build-script edges still maturing (`OUT_DIR` symlink and native search paths not
yet cacheable), and no cross-machine cache. For the local multi-worktree loop
here those costs are outweighed by the warm-rebuild speed, cross-worktree
`target/` dedup, and zero linker dependencies.

## References

- [mr-boxington — home](https://mr-boxington.jdx.dev/)
- [Getting started](https://mr-boxington.jdx.dev/getting-started)
- [How it works](https://mr-boxington.jdx.dev/how-it-works)
- [Configuration](https://mr-boxington.jdx.dev/configuration)
- [Managed target directories](https://mr-boxington.jdx.dev/managed-targets)
- [Managed linkers](https://mr-boxington.jdx.dev/linkers)
- [Mise configuration — wrappers](https://mise.jdx.dev/configuration.html)
- [sccache](https://github.com/mozilla/sccache)
