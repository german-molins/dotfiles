# Operations

Operators and language constructs ordered by precedence from **high** to **low**:

| Operation | Syntax |
|---|---|
| Square, cube, ... | `x²`, `x³`, `x⁻¹`, ... |
| Factorials | `x!`, `x!!`, `x!!!`, ... |
| Exponentiation | `x^y`, `x**y` |
| Multiplication (implicit) | `x y` (whitespace) |
| Unary negation | `-x` |
| Division (per) | `x per y` |
| Division | `x / y`, `x ÷ y` |
| Multiplication (explicit) | `x * y`, `x · y`, `x × y` |
| Subtraction | `x - y` |
| Addition | `x + y` |
| Comparisons | `x < y`, `x <= y`, `x ≤ y`, `x >= y`, `x ≥ y`, `x == y`, `x != y` |
| Logical negation | `!x` |
| Logical AND | `x && y` |
| Logical OR | `x \|\| y` |
| Unit conversion | `x -> y`, `x → y`, `x ➞ y`, `x to y` |
| Conditionals | `if x then y else z` |
| Reverse function call | `x \|> f` |

## Precedence notes

- **Implicit multiplication** has higher precedence than division: `50 cm / 2 m` parses as `50 cm / (2 m)`.
- **`per`-division** has higher precedence than `/`-division: `1 / meter per second` parses as `1 / (meter / second)`.

## Conversions

### Basic

```nbt
120 km/h -> mph
1600 kcal / day -> W
```

### Advanced (how many X fit in Y)

```nbt
6 hours -> 45 min          # = 8 × 45 min
```

### Convert to same unit as another quantity

```nbt
let v1 = 50 km / h
let v2 = 3 m/s -> unit_of(v1)     # 10.8 km/h
```

### Conversion functions

```nbt
now() -> unixtime_s             # DateTime to UNIX timestamp
now() -> tz("Asia/Kathmandu")   # timezone conversion
10 million seconds -> human     # human-readable duration
48.7756° -> DMS                 # degrees, minutes, seconds
1.75 m -> feet_and_inches
70 kg -> pounds_and_ounces
42 -> bin                       # binary representation
42 -> oct                       # octal
2^31-1 -> hex                   # hexadecimal
0x2764 -> chr                   # code point to character
"❤" -> ord                     # character to code point
"text" -> uppercase
"TEXT" -> lowercase
```

### Temperature conversions

`°C` and `°F` are offset units. They can only be used to enter temperatures and as conversion targets:

```nbt
25 °C                  # = 298.15 K
25 °C -> °F            # = 77
300 K -> °C            # = 26.85
```

**Warning**: `10 °C + 1 °C` gives `557.3 K` (not `11 °C`) because both are converted to Kelvin. Use `10 °C + 1 K` for temperature differences. Subtraction is fine: `20 °C - 10 °C = 10 K`.
