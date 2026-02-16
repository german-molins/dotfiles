# Standard Library Reference

## Table of Contents

- [Mathematical functions](#mathematical-functions)
- [List functions](#list-functions)
- [String functions](#string-functions)
- [Date and time functions](#date-and-time-functions)
- [Other functions](#other-functions)
- [Units](#units)

---

## Mathematical functions

### Basics

| Function | Signature | Description |
|---|---|---|
| `id` | `fn id<A>(x: A) -> A` | Identity function |
| `abs` | `fn abs<T: Dim>(x: T) -> T` | Absolute value |
| `sqrt` | `fn sqrt<D: Dim>(x: D²) -> D` | Square root |
| `cbrt` | `fn cbrt<D: Dim>(x: D³) -> D` | Cube root |
| `sqr` | `fn sqr<D: Dim>(x: D) -> D²` | Square |
| `round` | `fn round(x: Scalar) -> Scalar` | Round to nearest integer |
| `round_in` | `fn round_in<D: Dim>(base: D, value: D) -> D` | Round to nearest multiple of base |
| `floor` | `fn floor(x: Scalar) -> Scalar` | Floor |
| `floor_in` | `fn floor_in<D: Dim>(base: D, value: D) -> D` | Floor to multiple of base |
| `ceil` | `fn ceil(x: Scalar) -> Scalar` | Ceiling |
| `ceil_in` | `fn ceil_in<D: Dim>(base: D, value: D) -> D` | Ceiling to multiple of base |
| `trunc` | `fn trunc(x: Scalar) -> Scalar` | Truncation towards zero |
| `trunc_in` | `fn trunc_in<D: Dim>(base: D, value: D) -> D` | Truncation to multiple of base |
| `fract` | `fn fract(x: Scalar) -> Scalar` | Fractional part |
| `mod` | `fn mod<T: Dim>(a: T, b: T) -> T` | Modulo (least nonnegative remainder) |
| `parse` | `fn parse<T: Dim>(input: String) -> T` | Parse string as quantity |
| `args` | `fn args() -> List<String>` | Command-line arguments |

### Transcendental

| Function | Signature |
|---|---|
| `exp` | `fn exp(x: Scalar) -> Scalar` |
| `ln` | `fn ln(x: Scalar) -> Scalar` |
| `log` | `fn log(x: Scalar) -> Scalar` (alias for `ln`) |
| `log10` | `fn log10(x: Scalar) -> Scalar` |
| `log2` | `fn log2(x: Scalar) -> Scalar` |
| `gamma` | `fn gamma(x: Scalar) -> Scalar` |

### Trigonometry

| Function | Signature |
|---|---|
| `sin`, `cos`, `tan` | `fn ...(x: Scalar) -> Scalar` |
| `asin`, `acos`, `atan` | `fn ...(x: Scalar) -> Scalar` |
| `atan2` | `fn atan2<T: Dim>(y: T, x: T) -> Scalar` |
| `sinh`, `cosh`, `tanh` | `fn ...(x: Scalar) -> Scalar` |
| `asinh`, `acosh`, `atanh` | `fn ...(x: Scalar) -> Scalar` |
| `cot`, `acot`, `coth`, `acoth` | `fn ...(x: Scalar) -> Scalar` |
| `secant`, `arcsecant` | `fn ...(x: Scalar) -> Scalar` |
| `cosecant`, `csc`, `acsc` | `fn ...(x: Scalar) -> Scalar` |
| `sech`, `asech`, `csch`, `acsch` | `fn ...(x: Scalar) -> Scalar` |

### Statistics

| Function | Signature | Description |
|---|---|---|
| `maximum` | `fn maximum<D: Dim>(xs: List<D>) -> D` | Largest element |
| `minimum` | `fn minimum<D: Dim>(xs: List<D>) -> D` | Smallest element |
| `mean` | `fn mean<D: Dim>(xs: List<D>) -> D` | Arithmetic mean |
| `variance` | `fn variance<D: Dim>(xs: List<D>) -> D²` | Population variance |
| `stdev` | `fn stdev<D: Dim>(xs: List<D>) -> D` | Population std deviation |
| `median` | `fn median<D: Dim>(xs: List<D>) -> D` | Median |

### Combinatorics

| Function | Signature | Description |
|---|---|---|
| `factorial` | `fn factorial(n: Scalar) -> Scalar` | n! (also postfix `n!`) |
| `falling_factorial` | `fn falling_factorial(n, k: Scalar) -> Scalar` | n×(n-1)×...×(n-k+1) |
| `binom` | `fn binom(n, k: Scalar) -> Scalar` | Binomial coefficient |
| `fibonacci` | `fn fibonacci(n: Scalar) -> Scalar` | Fibonacci numbers |
| `lucas` | `fn lucas(n: Scalar) -> Scalar` | Lucas numbers |
| `catalan` | `fn catalan(n: Scalar) -> Scalar` | Catalan numbers |

### Random sampling

| Function | Signature |
|---|---|
| `random` | `fn random() -> Scalar` — uniform [0,1) |
| `rand_uniform` | `fn rand_uniform<T: Dim>(a: T, b: T) -> T` |
| `rand_int` | `fn rand_int(a, b: Scalar) -> Scalar` |
| `rand_bernoulli` | `fn rand_bernoulli(p: Scalar) -> Scalar` |
| `rand_binom` | `fn rand_binom(n, p: Scalar) -> Scalar` |
| `rand_norm` | `fn rand_norm<T: Dim>(μ: T, σ: T) -> T` |
| `rand_geom` | `fn rand_geom(p: Scalar) -> Scalar` |
| `rand_poisson` | `fn rand_poisson(λ: Scalar) -> Scalar` |
| `rand_expon` | `fn rand_expon<T: Dim>(λ: T) -> 1/T` |
| `rand_lognorm` | `fn rand_lognorm(μ, σ: Scalar) -> Scalar` |
| `rand_pareto` | `fn rand_pareto<T: Dim>(α: Scalar, min: T) -> T` |

### Number theory

| Function | Signature | Description |
|---|---|---|
| `gcd` | `fn gcd(a, b: Scalar) -> Scalar` | Greatest common divisor |
| `lcm` | `fn lcm(a, b: Scalar) -> Scalar` | Least common multiple |

### Numerical methods

**Note:** All numerical methods require importing the appropriate module: `use numerics::diff`, `use numerics::solve`, or `use numerics::fixed_point`.

#### Root Finding

| Function | Signature | Description |
|---|---|---|
| `root_bisect` | `fn root_bisect<X: Dim, Y: Dim>(f: Fn[(X) -> Y], x1: X, x2: X, x_tol: X, y_tol: Y) -> X` | Root finding via bisection method. Requires brackets `[x1, x2]` where `f(x1)` and `f(x2)` have opposite signs. Tolerances control convergence: `x_tol` for x-axis, `y_tol` for function value. Module: `numerics::solve` |
| `root_newton` | `fn root_newton<X: Dim, Y: Dim>(f: Fn[(X) -> Y], f_prime: Fn[(X) -> Y / X], x0: X, y_tol: Y) -> X` | Root finding via Newton's method. Requires the derivative `f_prime` and initial guess `x0`. Faster than bisection but needs accurate derivative. Module: `numerics::solve` |

**Example:**
```sh
numbat <<'EOF'
use numerics::solve

fn f(x) = cos(x) - x
let root = root_bisect(f, 0, 1, 1e-6, 1e-6)
print("cos(x) = x when x ≈ {root}")
EOF
```

#### Derivatives and ODE Solving

| Function | Signature | Description |
|---|---|---|
| `diff` | `fn diff<X: Dim, Y: Dim>(f: Fn[(X) -> Y], x: X) -> Y / X` | Numerical derivative via central difference at point `x`. Module: `numerics::diff` |
| `dsolve_runge_kutta` | `fn dsolve_runge_kutta<X: Dim, Y: Dim>(f: Fn[(X, Y) -> Y / X], x_start: X, y_start: Y, x_end: X, step: X) -> Y` | 4th-order Runge-Kutta ODE solver. Solves `dy/dx = f(x, y)`. Module: `numerics::diff` |

#### Fixed-Point Iteration

| Function | Signature | Description |
|---|---|---|
| `fixed_point` | `fn fixed_point<A>(f: Fn[(A) -> A], x0: A, tolerance: A) -> A` | Fixed-point iteration: finds `x` where `f(x) = x`. Module: `numerics::fixed_point` |

### Percentage calculations

| Function | Description |
|---|---|
| `increase_by(pct, qty)` | `72 € \|> increase_by(15%)` → `82.8 €` |
| `decrease_by(pct, qty)` | `210 cm \|> decrease_by(10%)` → `189 cm` |
| `percentage_change(old, new)` | `percentage_change(35 kg, 42 kg)` → `20 %` |

### Geometry

| Function | Description |
|---|---|
| `hypot2(x, y)` | Hypotenuse `sqrt(x²+y²)` |
| `hypot3(x, y, z)` | 3D norm `sqrt(x²+y²+z²)` |
| `circle_area(r)` | `π r²` |
| `circle_circumference(r)` | `2πr` |
| `sphere_area(r)` | `4πr²` |
| `sphere_volume(r)` | `(4/3)πr³` |

### Algebra

Requires `use extra::algebra`.

| Function | Description |
|---|---|
| `quadratic_equation(a, b, c)` | Solve ax²+bx+c=0 |
| `cubic_equation(a, b, c, e)` | Solve ax³+bx²+cx+e=0 |

---

## List functions

| Function | Signature | Description |
|---|---|---|
| `len` | `fn len<A>(xs: List<A>) -> Scalar` | Length |
| `head` | `fn head<A>(xs: List<A>) -> A` | First element |
| `tail` | `fn tail<A>(xs: List<A>) -> List<A>` | All but first |
| `cons` | `fn cons<A>(x: A, xs: List<A>) -> List<A>` | Prepend |
| `cons_end` | `fn cons_end<A>(x: A, xs: List<A>) -> List<A>` | Append |
| `is_empty` | `fn is_empty<A>(xs: List<A>) -> Bool` | Empty check |
| `concat` | `fn concat<A>(xs1, xs2: List<A>) -> List<A>` | Concatenate |
| `take` | `fn take<A>(n: Scalar, xs: List<A>) -> List<A>` | First n |
| `drop` | `fn drop<A>(n: Scalar, xs: List<A>) -> List<A>` | Skip first n |
| `element_at` | `fn element_at<A>(i: Scalar, xs: List<A>) -> A` | Index access |
| `range` | `fn range(start, end: Scalar) -> List<Scalar>` | Integer range (inclusive) |
| `reverse` | `fn reverse<A>(xs: List<A>) -> List<A>` | Reverse |
| `map` | `fn map<A,B>(f: Fn[(A)->B], xs: List<A>) -> List<B>` | Map function |
| `filter` | `fn filter<A>(p: Fn[(A)->Bool], xs: List<A>) -> List<A>` | Filter |
| `foldl` | `fn foldl<A,B>(f: Fn[(A,B)->A], acc: A, xs: List<B>) -> A` | Left fold |
| `sort` | `fn sort<D: Dim>(xs: List<D>) -> List<D>` | Sort ascending |
| `sort_by_key` | `fn sort_by_key<A,D: Dim>(key: Fn[(A)->D], xs: List<A>) -> List<A>` | Sort by key |
| `contains` | `fn contains<A>(x: A, xs: List<A>) -> Bool` | Membership |
| `unique` | `fn unique<A>(xs: List<A>) -> List<A>` | Deduplicate |
| `intersperse` | `fn intersperse<A>(sep: A, xs: List<A>) -> List<A>` | Intersperse |
| `sum` | `fn sum<D: Dim>(xs: List<D>) -> D` | Sum |
| `linspace` | `fn linspace<D: Dim>(start, end: D, n: Scalar) -> List<D>` | Evenly spaced |
| `join` | `fn join(xs: List<String>, sep: String) -> String` | Join strings |
| `split` | `fn split(input, sep: String) -> List<String>` | Split string |

---

## String functions

| Function | Signature | Description |
|---|---|---|
| `str_length` | `fn str_length(s: String) -> Scalar` | String length |
| `str_slice` | `fn str_slice(start, end: Scalar, s: String) -> String` | Substring |
| `chr` | `fn chr(n: Scalar) -> String` | Code point to char |
| `ord` | `fn ord(s: String) -> Scalar` | Char to code point |
| `lowercase` | `fn lowercase(s: String) -> String` | To lowercase |
| `uppercase` | `fn uppercase(s: String) -> String` | To uppercase |
| `str_append` | `fn str_append(a, b: String) -> String` | Concatenate |
| `str_prepend` | `fn str_prepend(a, b: String) -> String` | Concatenate |
| `str_find` | `fn str_find(needle, haystack: String) -> Scalar` | Find substring |
| `str_contains` | `fn str_contains(needle, haystack: String) -> Bool` | Contains check |
| `str_replace` | `fn str_replace(pat, repl, s: String) -> String` | Replace all |
| `str_repeat` | `fn str_repeat(n: Scalar, s: String) -> String` | Repeat n times |
| `base` | `fn base(b, x: Scalar) -> String` | Number to base b |
| `bin` | `fn bin(x: Scalar) -> String` | Binary repr |
| `oct` | `fn oct(x: Scalar) -> String` | Octal repr |
| `dec` | `fn dec(x: Scalar) -> String` | Decimal repr |
| `hex` | `fn hex(x: Scalar) -> String` | Hexadecimal repr |

---

## Date and time functions

| Function | Signature | Description |
|---|---|---|
| `now` | `fn now() -> DateTime` | Current date and time |
| `today` | `fn today() -> DateTime` | Current date at midnight |
| `datetime` | `fn datetime(s: String) -> DateTime` | Parse date+time string |
| `date` | `fn date(s: String) -> DateTime` | Parse date string |
| `time` | `fn time(s: String) -> DateTime` | Parse time string |
| `format_datetime` | `fn format_datetime(fmt, dt: DateTime) -> String` | Format datetime |
| `tz` | `fn tz(tz: String) -> Fn[(DateTime)->DateTime]` | Timezone converter |
| `local` | `fn local(dt: DateTime) -> DateTime` | Convert to local tz |
| `get_local_timezone` | `fn get_local_timezone() -> String` | Local timezone name |
| `unixtime_s` | `fn unixtime_s(dt: DateTime) -> Scalar` | To UNIX timestamp (s) |
| `unixtime_ms` | `fn unixtime_ms(dt: DateTime) -> Scalar` | To UNIX timestamp (ms) |
| `unixtime_µs` | `fn unixtime_µs(dt: DateTime) -> Scalar` | To UNIX timestamp (µs) |
| `from_unixtime_s` | `fn from_unixtime_s(t: Scalar) -> DateTime` | From UNIX timestamp (s) |
| `from_unixtime_ms` | `fn from_unixtime_ms(t: Scalar) -> DateTime` | From UNIX timestamp (ms) |
| `from_unixtime_µs` | `fn from_unixtime_µs(t: Scalar) -> DateTime` | From UNIX timestamp (µs) |
| `calendar_add` | `fn calendar_add(dt: DateTime, span: Time) -> DateTime` | DST/leap-aware add |
| `calendar_sub` | `fn calendar_sub(dt: DateTime, span: Time) -> DateTime` | DST/leap-aware subtract |
| `weekday` | `fn weekday(dt: DateTime) -> String` | Day of week |
| `human` | `fn human(t: Time) -> String` | Human-readable duration |
| `julian_date` | `fn julian_date(dt: DateTime) -> Time` | Julian date |
| `from_julian_date` | `fn from_julian_date(jd: Time) -> DateTime` | From Julian date |

### DateTime arithmetic

| Left | Op | Right | Result |
|---|---|---|---|
| `DateTime` | `-` | `DateTime` | Duration (`Time`) |
| `DateTime` | `+` | `Time` | New `DateTime` |
| `DateTime` | `-` | `Time` | New `DateTime` |
| `DateTime` | `->` | `tz("...")` | Timezone conversion |

### Supported datetime formats

**`datetime()`**: RFC 3339 (`2024-02-10T12:30:00Z`), RFC 2822, `%Y-%m-%d %H:%M:%S`, `%Y/%m/%d %H:%M:%S`, 12-hour with AM/PM. Optional timezone suffix.

**`date()`**: `%Y-%m-%d`, `%Y/%m/%d`. Optional timezone.

**`time()`**: `%H:%M:%S`, `%H:%M`, 12-hour with AM/PM. Optional timezone.

---

## Other functions

### Error handling

| Function | Description |
|---|---|
| `error(msg: String)` | Throw runtime error |

### Debugging

| Function | Description |
|---|---|
| `inspect(x)` | Print value+type, return unchanged |
| `type(x)` | Print dimension type |

### Floating point

| Function | Description |
|---|---|
| `is_nan(n)` | True if NaN |
| `is_infinite(n)` | True if ±inf |
| `is_finite(n)` | True if not NaN/inf |
| `is_zero(n)` | True if 0 |
| `is_nonzero(n)` | True if not 0 |
| `is_integer(x)` | True if integer |

### Quantities

| Function | Description |
|---|---|
| `value_of(x)` | Extract numeric value |
| `unit_of(x)` | Extract unit |
| `base_unit_of(x)` | Extract base unit (no prefix) |
| `has_unit(qty, u)` | Check if same unit |
| `is_dimensionless(x)` | Check if dimensionless |
| `unit_name(x)` | Unit as string |

### Chemical elements

`element(pattern: String) -> ChemicalElement` — look up by symbol or name.

```nbt
element("Fe").melting_point -> °C     # 1538
element("H").ionization_energy        # 13.598 eV
```

### Mixed unit conversion

| Function | Description |
|---|---|
| `unit_list(units, value)` | `5500 m \|> unit_list([miles, yards, feet, inches])` |
| `DMS(angle)` | Degrees, minutes, seconds |
| `DM(angle)` | Degrees, decimal minutes |
| `feet_and_inches(length)` | Mixed feet + inches |
| `pounds_and_ounces(mass)` | Mixed pounds + ounces |

### Temperature conversion

| Function | Description |
|---|---|
| `from_celsius(t)` | Scalar → Temperature |
| `°C(t)` / `celsius(t)` | Temperature → Scalar (°C) |
| `from_fahrenheit(t)` | Scalar → Temperature |
| `°F(t)` / `fahrenheit(t)` | Temperature → Scalar (°F) |

### Speed of sound

`speed_of_sound(T_air: Temperature) -> Velocity` — in dry air at given temperature.

### Color format conversion

Requires `use extra::color`.

| Function | Description |
|---|---|
| `rgb(r, g, b)` | Create Color from RGB values |
| `color(hex)` | Create Color from hex value |
| `color_rgb(c)` | Color → `"rgb(r, g, b)"` |
| `color_hex(c)` | Color → `"#rrggbb"` |

### Celestial calculations

Requires `use extra::celestial`.

| Function | Description |
|---|---|
| `sunrise_sunset(pos, dt)` | Sunrise, transit, sunset times |
| `moon_phase(dt)` | Moon phase (0–1 lunar_cycle) |
| `moon_phase_name(phase)` | Phase name and symbol |

---

## Units

All SI-accepted units support metric prefixes. Binary prefixes supported where sensible.

### Key unit categories

**Length**: `m`, `km`, `cm`, `mm`, `in`, `ft`, `yd`, `mi`, `NM`, `ly`, `pc`, `au`, `Å`
**Mass**: `g`, `kg`, `lb`, `oz`, `ton`, `Da`
**Time**: `s`, `min`, `h`, `day`, `week`, `month`, `year`, `century`, `millennium`
**Velocity**: `m/s`, `km/h`, `kph`, `mph`, `knots`
**Force**: `N`, `lbf`, `kgf`, `dyn`
**Energy**: `J`, `eV`, `cal`, `BTU`, `Wh`, `erg`
**Power**: `W`, `hp`
**Pressure**: `Pa`, `bar`, `atm`, `psi`, `mmHg`, `torr`
**Temperature**: `K`, `°C`, `°F`
**Frequency**: `Hz`, `rpm`
**Electric**: `A`, `V`, `Ω`, `F`, `H`, `S`, `C`, `Wb`, `T`
**Volume**: `L`, `gal`, `cup`, `tbsp`, `tsp`, `floz`, `pint`
**Area**: `m²`, `ha`, `acre`, `barn`
**Angle**: `rad`, `deg`, `°`, `′`, `″`, `turn`, `rev`
**Digital**: `bit`, `byte`, `B`, `KB`, `MiB`, `GiB`
**Money**: `$`, `€`, `£`, `¥`, `₹`, `CHF`, `AUD`, `CAD`, `CNY`, `JPY`, etc.
**Scalar**: `%`, `‰`, `ppm`, `ppb`, `dozen`, `million`, `billion`
**Other**: `mol`, `Bq`, `Sv`, `Gy`, `cd`, `lm`, `lx`, `sr`, `people`, `pixel`

For the complete list, see https://numbat.dev/docs/prelude/list-units/.
