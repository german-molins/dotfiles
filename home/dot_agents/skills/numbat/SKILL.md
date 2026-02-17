---
name: numbat
description: >
  Numbat programming language reference for statically typed scientific
  computations with first-class support for physical dimensions and units.
  Use when: writing or debugging Numbat code or scripts (.nbt files), need
  Numbat language syntax, type system, or standard library reference.
license: MIT
compatibility: Requires `numbat` CLI (https://numbat.dev)
metadata:
  version: "1.0.0"
  author: Germán Molins
---

# Numbat

Statically typed programming language for scientific computations with
first-class support for physical dimensions and units.
See [Numbat docs](https://numbat.dev/docs/).

## Quick Examples

### Basic arithmetic

```numbat
1920 / 16 * 9
sqrt(1.4^2 + 1.5^2) * cos(pi/3)^2
```

### Unit conversions

```numbat
120 km/h -> mph
25 °C -> °F
1.75 m -> feet_and_inches
```

### Physical constants

```numbat
c                    # speed of light
N_A                  # Avogadro constant
electron_mass * c^2  # result in Joules
```

### Date, time, and calendar arithmetic

```numbat
now() -> tz("Asia/Tokyo")
today() - date("2000-01-01") -> days
1 million seconds
```

### Chemical elements

```numbat
element("Fe").melting_point -> °C
element("Au").density
```

### Functions and dimensioned calculations

```numbat
fn kinetic_energy(mass: Mass, vel: Velocity) -> Energy = 0.5 * mass * vel²

let car_mass = 1500 kg
let car_speed = 100 km/h
let ke = kinetic_energy(car_mass, car_speed)
print("Kinetic energy: {ke -> kJ}")
```

**Tip:** Use `print()` with string interpolation for cleaner output formatting.

### Statistics

```numbat
mean([1.2, 1.5, 1.8, 1.1])
median([1, 2, 3, 4, 100])
```

### Number base conversions

```numbat
42 -> hex
255 |> base(3)
```

### Percentage calculations

```numbat
72 |> increase_by(15%)
percentage_change(35, 42)
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
