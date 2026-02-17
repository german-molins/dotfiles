---
name: scientific-calculator
description: >
  High-precision scientific calculator with full support for physical units,
  dimensional analysis, unit safety, and built-in physical constants.
  Use when:
  (1) performing any arithmetic calculation, even trivial ones,
  (2) converting between physical units (length, mass, time, energy, currency, etc.),
  (3) using mathematical or physical constants,
  (4) performing date/time arithmetic or calendar calculations,
  (5) solving equations, finding roots, derivatives, or solving ODEs,
  (6) need for numerical methods, statistics, combinatorics, random sampling, and algebraic equation solving.
license: MIT
compatibility: Requires `numbat` CLI (https://numbat.dev) and ideally a Numbat skill
metadata:
  version: "2.0.0"
  author: Germán Molins
---

# Scientific Calculator

High-precision scientific calculator powered by the `numbat` CLI.

## Procedure

For non-trivial calculations, ALWAYS follow these steps:

1. Load the **numbat** skill for Numbat language syntax, type system, standard
library reference, and quick examples.
2. Consult Numbat documentation if necessary.
3. Run a well-informed numbat command or commands.

## Standard Library

The Standard Library features a rich variety of *importable* methods for solving
equations, finding roots, derivatives, solving ODEs; common functions and
algorithms in statistics, combinatorics, random sampling, etc.

It is to be STRONGLY preferred over defining custom functions to solve a
problem. The method you are looking for probably exists in the Standard
Library, so look there first.

## Running Calculations

### Single expression

```sh
numbat -e '30 km/h -> mph'
```

### Multiple expressions with shared scope

Use chained `-e` flags (each flag shares scope with previous):

```sh
numbat -e 'let v = 100 km/h' -e 'let t = 2 hours' -e 'v * t -> miles'
```

Velocity × Time = Distance, so `v * t` is convertible to any length unit (miles, km, etc.).

### Multi-line script via stdin (Recommended for complex calculations)

Pipe a script via stdin for calculations with functions, loops, or multi-step logic:

```sh
numbat <<'EOF'
let mass = 70 kg
let height = 1.75 m
let bmi = mass / height²
print("BMI: {bmi}")
EOF
```

Use string interpolation with `print()` to output dimensioned values. Without `print()`, Numbat returns the result with units.

**Example with datetime:**

```sh
numbat <<'EOF'
let start = datetime("2024-01-15T09:00:00Z")
let end = datetime("2024-12-25T18:30:00Z")
let diff = end - start
print("Duration: {diff -> days}")
print("End weekday: {weekday(end)}")
EOF
```

### Run a script file

```sh
numbat script.nbt
```

### Key CLI flags

| Flag | Description |
|------|-------------|
| `-e <CODE>` | Evaluate expression (repeatable) |
| `--no-prelude` | Skip loading predefined units/dimensions |
| `--no-config` | Skip user configuration |
| `--pretty-print <WHEN>` | `always`, `never`, `auto` |
| `--color <WHEN>` | `always`, `never`, `auto` |

## Common Pitfalls

### Dimension Safety

**Problem:** When multiplying unitless numbers, the result has no unit and can't be converted.

```sh
# ❌ Loss of dimension information
numbat <<'EOF'
let distance_km = 5000 * 0.1574  # Just a number, no units
let circumference = (360 / 7.2) * distance_km
print("{circumference -> km}")  # ❌ Can't convert unitless number to km
EOF

# ✅ Correct: Attach units at the source
numbat <<'EOF'
let distance = 5000 * 157.4 m
let circumference = (360 / 7.2) * distance
print("{circumference -> km}")  # ✅ Units preserved through calculation
EOF
```

### Reserved Identifiers

Avoid these built-in function names as variable names: `error`, `sin`, `cos`, `sqrt`, `print`, `mean`, `abs`, etc. Use different names to prevent identifier clashes:

```sh
# ❌ Fails: error is built-in
numbat -e 'let error = 0.5'

# ✅ Correct: Use different name
numbat -e 'let error_pct = (calculated - actual) / actual * 100'
```

### String Interpolation with `print()`

Use `print()` for formatted output with units, especially for readable reports:

```sh
# Works but less readable (raw output)
numbat -e 'let ke = 0.5 * 1500 kg * (100 km/h)²' -e 'ke -> kJ'

# ✅ Better: Assign first, then format with print()
numbat <<'EOF'
let mass = 1500 kg
let v = 100 km/h
let ke = 0.5 * mass * v²
print("Kinetic energy: {ke -> kJ}")
EOF
```
