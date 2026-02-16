---
name: scientific-calculator
description: >
  High-precision scientific calculator with full support for physical units,
  powered by Numbat CLI. Provides dimensional analysis, unit safety, and
  built-in physical constants. Use when:
  (1) performing any arithmetic calculation, even trivial ones,
  (2) converting between physical units (length, mass, time, energy, currency, etc.),
  (3) using mathematical or physical constants,
  (4) performing date/time arithmetic or calendar calculations,
  (5) solving equations, finding roots, derivatives, or solving ODEs,
  (6) user explicitly mentions "numbat" or "scientific calculator".
  (7) need for numerical methods, statistics, combinatorics, random sampling, and algebraic equation solving.
license: MIT
compatibility: Requires `numbat` CLI (https://numbat.dev)
metadata:
  version: "1.0.0"
  author: Germán Molins
---

# Scientific Calculator (Numbat)

High-precision scientific calculator with first-class support for physical
dimensions and units via [Numbat](https://numbat.dev/docs/), a statically typed
programming language for scientific computations.

## Running Numbat

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

## Quick examples

### Basic arithmetic

```sh
numbat -e '1920 / 16 * 9'
numbat -e 'sqrt(1.4^2 + 1.5^2) * cos(pi/3)^2'
```

### Unit conversions

```sh
numbat -e '120 km/h -> mph'
numbat -e '25 °C -> °F'
numbat -e '1.75 m -> feet_and_inches'
```

### Physical constants

```sh
numbat -e 'c'                    # speed of light
numbat -e 'N_A'                  # Avogadro constant
numbat -e 'electron_mass * c^2'  # Result in Joules
```

### Date, time, and calendar arithmetic

```sh
numbat -e 'now() -> tz("Asia/Tokyo")'
numbat -e 'today() - date("2000-01-01") -> days'
numbat -e '1 million seconds' | numbat
```

### Chemical elements

```sh
numbat -e 'element("Fe").melting_point -> °C'
numbat -e 'element("Au").density'
```

### Functions and dimensioned calculations

```sh
numbat <<'EOF'
fn kinetic_energy(mass: Mass, vel: Velocity) -> Energy = 0.5 * mass * vel²

let car_mass = 1500 kg
let car_speed = 100 km/h
let ke = kinetic_energy(car_mass, car_speed)
print("Kinetic energy: {ke -> kJ}")
EOF
```

**Tip:** Use `print()` with string interpolation for cleaner, more explicit output formatting.

### Statistics

```sh
numbat -e 'mean([1.2, 1.5, 1.8, 1.1])'
numbat -e 'median([1, 2, 3, 4, 100])'
```

### Number base conversions

```sh
numbat -e '42 -> hex'
numbat -e '255 |> base(3)'
```

### Percentage calculations

```sh
numbat -e '72 |> increase_by(15%)'
numbat -e 'percentage_change(35, 42)'
```

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

## Standard Library

The Standard Library features a rich variety of *importable* methods for solving
equations, finding roots, derivatives, solving ODEs; common functions and
algorithms in statistics, combinatorics, random sampling, etc.

It is to be STRONGLY preferred over defining custom functions to solve a
problem. The method you are looking for probably exists in the Standard
Library, so look there first.

ALWAYS proceed like this:

1. Search the [Standard Library](references/standard-library.md) by keywords
   (often truncated names) for your desired method. NEVER try to guess a method
*signature* or *name*, even if you are confident that you know it. Look first
for the exact method name and signature before trying to use it.
2. If you don't find your desired method, then you may proceed to define a
   custom function.

## References

- [Operations](references/operations.md) — full precedence table and conversion patterns
- [Functions and control flow](references/functions-and-control-flow.md) — function definitions, conditionals, pipe operator, and example programs
- [Variables and data structures](references/variables-and-data-structures.md) — variables, numbers, units, lists, structs, dimension/unit definitions
- [Constants](references/constants.md) — mathematical and physical constants
- [Standard library](references/standard-library.md) — all stdlib functions (math, lists, strings, datetime, chemical elements, etc.) and unit categories
