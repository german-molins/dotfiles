# Variables and Data Structures

## Table of Contents

- [Variables](#variables)
- [Number notation](#number-notation)
- [Unit notation](#unit-notation)
- [Lists](#lists)
- [Structs](#structs)
- [Dimension definitions](#dimension-definitions)
- [Unit definitions](#unit-definitions)
- [Type system](#type-system)

---

## Variables

Introduce with `let`. Variables are immutable but can be redefined.

```nbt
let pipe_radius = 1 cm
let pipe_length = 10 m
let Δp = 0.1 bar
```

Optional type annotation:

```nbt
let μ_water: DynamicViscosity = 1 mPa·s
let Q: FlowRate = π × pipe_radius^4 × Δp / (8 μ_water × pipe_length)
```

Redefinition (creates new binding):

```nbt
let numbers = "1 2 3"
let numbers = split(numbers, " ")
```

---

## Number notation

| Form | Examples |
|------|---------|
| Integer | `12345`, `12_345` |
| Floating point | `0.234`, `.234` |
| Scientific | `1.234e15`, `1e-9` |
| Hexadecimal | `0x2A` |
| Octal | `0o52` |
| Binary | `0b101010` |
| Special | `NaN`, `inf` |

Base conversion functions: `bin`, `oct`, `dec`, `hex`, `base(b, n)`.

```nbt
0xffee -> bin
42 -> oct
2^16 - 1 -> hex
273 |> base(3)
```

Internal representation: 64-bit floating point (~15-16 significant digits).

---

## Unit notation

Units have long forms (`meter`), plural forms (`meters`), and short aliases (`m`).

SI metric prefixes (`mm`, `cm`, `km`, ...) and binary prefixes (`MiB`, `GiB`, ...) supported.

Units combine with math operations: `kg * m/s^2`, `km/h`, `m²`.

```nbt
2 min + 1 s
150 cm
sin(30°)
50 mph
6 MiB
25 °C
```

---

## Lists

Created with `[...]`. Type: `List<T>`.

```nbt
[30 cm, 110 cm, 2 m]
["a", "b", "c"]
[[1, 2], [3, 4]]
```

Key operations:

```nbt
len([1, 2, 3])                           # 3
sum([30 cm, 130 cm, 2 m])               # 360 cm
mean([30 cm, 130 cm, 2 m])              # 120 cm
filter(is_finite, [20 cm, inf, 1 m])    # [20 cm, 1 m]
map(sqr, [10 cm, 2 m])                  # [100 cm², 4 m²]
range(1, 5)                              # [1, 2, 3, 4, 5]
linspace(0 m, 1 m, 5)                   # [0 m, 0.25 m, 0.5 m, 0.75 m, 1 m]
sort([3, 1, 2])                          # [1, 2, 3]
reverse([1, 2, 3])                       # [3, 2, 1]
head([3, 2, 1])                          # 3
tail([3, 2, 1])                          # [2, 1]
cons(0, [1, 2])                          # [0, 1, 2]
concat([1, 2], [3, 4])                   # [1, 2, 3, 4]
take(2, [3, 2, 1, 0])                   # [3, 2]
drop(2, [3, 2, 1, 0])                   # [1, 0]
element_at(1, [10, 20, 30])             # 20
contains(2, [1, 2, 3])                  # true
unique([1, 2, 2, 3])                    # [1, 2, 3]
join(["a", "b"], "-")                   # "a-b"
split("a-b", "-")                       # ["a", "b"]
foldl(str_append, "", ["a", "b"])       # "ab"
sort_by_key(abs, [3, -1, 2])           # [-1, 2, 3]
```

---

## Structs

Define with `struct`, instantiate with `{ field: value }`, access with `.`:

```nbt
struct Element {
    name: String,
    atomic_number: Scalar,
    density: MassDensity,
}

let tungsten = Element {
    name: "Tungsten",
    atomic_number: 74,
    density: 19.25 g/cm³,
}

tungsten.density
```

Generic structs:

```nbt
struct Vec2<D: Dim> {
    x: D,
    y: D,
}

let position = Vec2 { x: 1 m, y: 2 m }
let velocity: Vec2<Velocity> = Vec2 { x: 1 m/s, y: 2 m/s }
```

---

## Dimension definitions

```nbt
dimension Fame
dimension Deceleration = Length / Time^2
```

---

## Unit definitions

```nbt
@aliases(quorks)
unit quork = 0.35 meter

@metric_prefixes
@aliases(ck: short)
unit clonk: Time = 0.2 seconds

@metric_prefixes
@aliases(wh: short)
unit warhol: Fame

unit thing
```

Decorators:
- `@aliases(...)` — define alternative names. `: short` for short-form prefixes.
- `@metric_prefixes` — allow SI prefixes (milli-, kilo-, etc.).

---

## Type system

Built-in types: `Scalar`, `Bool`, `String`, `DateTime`, `List<T>`.

Dimension types: `Length`, `Time`, `Mass`, `Velocity`, `Energy`, `Pressure`, `Temperature`, `Force`, `Power`, `Frequency`, `ElectricCharge`, `Voltage`, etc.

Type parameters use `<T: Dim>` for dimension-constrained generics, `<A>` for unconstrained.

Typed holes for exploration:

```nbt
>>> let x: ? = mass / mass
  = 1
```

Numbat fills in `?` with the inferred type.
