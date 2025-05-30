# Conventions

## Python

### General

- Use type hints everywhere possible.
- Use `pathlib` for system paths.

### Docstrings

- Use Markdown syntax (headers, `monospace`, latex, etc.) in the description.

### Functions

- When creating a new function, include descriptive docstrings, with sphinx
  style for the parameters (don't specify types).
- Update the docstring when modifying a function.
- Never hardcode constant values that can be derived from other values. Assign
  it to a variable instead.
- Place definition of constants at the beginning of the function.
- If possible, don't nest parentheses; use intermediate variables instead.

### Tests

- `mock`: Mock objects and patch functions and classes as much as possible.
- Use `pytest`: fixtures, parametrized tests, etc.
