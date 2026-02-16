# Functions and Control Flow

## Table of Contents

- [Functions](#functions)
  - [Definition](#definition)
  - [Type inference](#type-inference)
  - [Generic functions](#generic-functions)
  - [Recursive functions](#recursive-functions)
  - [Where clauses](#where-clauses)
- [Conditionals](#conditionals)
- [Pipe operator](#pipe-operator)
- [Printing and strings](#printing-and-strings)
  - [String interpolation](#string-interpolation)
  - [Format specifiers](#format-specifiers)
- [Testing and debugging](#testing-and-debugging)
- [Example programs](#example-programs)

---

## Functions

### Definition

```nbt
fn max_distance(v: Velocity, θ: Angle) -> Length = v² · sin(2 θ) / g0
```

Annotate types explicitly for clarity. Numbat infers the return type.

```nbt
fn speed(len: Length, dur: Time) -> Velocity = len / dur
fn my_sqrt<T: Dim>(q: T^2) -> T = q^(1/2)
fn is_non_negative(x: Scalar) -> Bool = x ≥ 0
```

### Type inference

Numbat infers missing types from context. All types below are inferred:

```nbt
fn braking_distance(v) = v t_reaction + v² / 2 µ g0
  where t_reaction = 1 s
    and µ = 0.7
```

Inferred signature: `fn braking_distance(v: Velocity) -> Length`.

Annotate explicitly to avoid overly generic signatures:

```nbt
fn kinetic_energy(mass, speed) = 1/2 * mass * speed^2
```

Inferred as `fn kinetic_energy<A: Dim, B: Dim>(mass: A, speed: B) -> A × B²` — better to annotate explicitly as `Mass` and `Velocity`.

### Generic functions

Type parameters in angle brackets, constrained with `Dim` for dimension types:

```nbt
fn max<D: Dim>(a: D, b: D) -> D =
  if a > b then a else b

fn cube_root<T>(x: T^3) -> T = x^(1/3)

fn second_element<A>(xs: List<A>) -> A =
  head(tail(xs))
```

### Recursive functions

```nbt
fn fib(n) =
  if n ≤ 2
    then 1
    else fib(n - 2) + fib(n - 1)
```

### Where clauses

Local variables with `where ... and`:

```nbt
fn power_4(x: Scalar) = z
  where y = x * x
    and z = y * y
```

---

## Conditionals

```nbt
if <cond> then <expr1> else <expr2>
```

Treat conditionals as expressions, not statements. Match types in both branches.

```nbt
fn step(x) = if x < 0 then 0 else 1
fn bump(x: Scalar) -> Scalar =
  if x >= 0 && x <= 1
    then 1
    else 0
```

---

## Pipe operator

`x |> f` is equivalent to `f(x)`. It has the lowest precedence.

```nbt
pi/3 + pi |> cos
72 € |> increase_by(15%)
range(1, 3) |> map(sqr) |> map(inspect) |> sum
```

---

## Printing and strings

```nbt
print(2 km/h)
print("hello world")
```

### String interpolation

Embed expressions in `{}` inside strings:

```nbt
print("3² + 4² = {hypot2(3, 4)}²")

let speed = 25 km/h
print("Speed: {speed} ({speed -> mph})")
```

### Format specifiers

```nbt
print("After {falling_time} of free fall, the speed is {falling_speed:.1}")
print("{value:>8.0f}")
print("{value:>6.1f}")
```

Use Rust-style format specifiers.

---

## Testing and debugging

### assert_eq

```nbt
assert_eq(2 + 3, 5)
assert_eq(1 ft × 77 in², 4 gal)
assert_eq(alpha, 1 / 137, 1e-4)
assert_eq(3.3 ft, 1 m, 1 cm)
```

### assert

```nbt
assert(1 yard < 1 meter)
assert("foobar" |> str_contains("foo"))
```

### type

```nbt
>>> type(g0)
  Length / Time²

>>> type(sqrt)
  forall A: Dim. Fn[(A²) -> A]
```

### inspect

Print value and type while returning the expression unchanged:

```nbt
>>> inspect(36 km / 1.5 hours) * 1 day
  inspect: 24 km/h    [Velocity]
    = 576 km    [Length]
```

---

## Example programs

### Body mass index

```nbt
unit BMI: Mass / Length^2 = kg / m^2

fn body_mass_index(mass: Mass, height: Length) =
    mass / height² -> BMI

print(body_mass_index(70 kg, 1.75 m))
```

### Flow rate in a pipe (Hagen-Poiseuille)

```nbt
let μ_water: DynamicViscosity = 1 mPa·s

fn flow_rate(radius: Length, length: Length, Δp: Pressure) -> FlowRate =
    π × radius^4 × Δp / (8 μ_water × length)

let pipe_radius = 1 cm
let pipe_length = 10 m
let Δp = 0.1 bar

let Q = flow_rate(pipe_radius, pipe_length, Δp)
print("Flow rate: {Q -> L/s}")
```

### Paper sizes (ISO 216)

```nbt
struct PaperSize {
    width: Length,
    height: Length,
}

fn paper_size_A(n: Scalar) -> PaperSize =
  if n == 0
    then PaperSize { width: 841 mm, height: 1189 mm }
    else PaperSize {
        width: floor_in(mm, paper_size_A(n - 1).height / 2),
        height: paper_size_A(n - 1).width,
      }

fn paper_area(size: PaperSize) -> Area = size.width * size.height
fn size_as_string(size: PaperSize) = "{size.width:>4} × {size.height:>5}   {paper_area(size) -> cm²:>6.1f}"
fn row(n) = "A{n:<3}   {size_as_string(paper_size_A(n))}"

print("Name    Width     Height        Area  ")
print("----   -------   --------   ----------")
print(join(map(row, range(0, 10)), "\n"))
```

### Population growth

```nbt
let initial_population = 50_000 people
let growth_rate = 2% per year

fn predict_population(t) =
    initial_population × e^(growth_rate·t) |> round_in(people)

print("Population in  20 years: {predict_population(20 years)}")
print("Population in 100 years: {predict_population(1 century)}")
```

### Voyager 1 photon budget

```nbt
let datarate = 160 bps
let f = 8.3 GHz
let P_transmit = 23 W
let ω = 2π f
let λ = c / f

@aliases(photon)
unit photons

let energy_per_photon = ℏ ω / photon
let photon_rate = P_transmit / energy_per_photon -> photons/s

let d_voyager = 3.7 m
let R = 23.5 billion kilometers
let d_receiver = 70 m

let irradiance = P_transmit / (4π R²)
let P_received: Power = irradiance × (π d_voyager / λ)² × (π d_receiver² / 4)

let photon_rate_receiver = P_received / energy_per_photon -> photons/s
let photons_per_bit = photon_rate_receiver / datarate -> photons/bit

print("Photons per bit from Voyager 1: {photons_per_bit:.0}")
```

### XKCD 687 — Dimensional analysis

```nbt
let core_pressure = 3.5 million atmospheres
let prius_milage = 50 miles per gallon
let min_width_channel = 21 miles

let r: Scalar =
    planck_energy / core_pressure × prius_milage / min_width_channel

print("{r} ≈ π ?")
```
