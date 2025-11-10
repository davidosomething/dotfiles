# Contributing

1. Install the dotfiles and zsh first so you get mise via zinit.
1. Install binaries and shell tools for this repo via mise

    ```sh
    mise trust
    mise install
    ```

1. Scripts for linting are in `package.json`

## Shell script code style

- **Script architecture**
  - Use the `#!/usr/bin/env bash` shebang and write with bash compatibility
  - Create a private main function with the same name as the shell script.
    E.g. for a script called `fun`, there should be a `__fun()` that gets
    called with the original arguments `__fun $@`
  - Two space indents
  - Prefer `.` over `source`
- **Function names**
  - For private functions in a script, use two underscores `__private_func()`
    These function names are safe to reuse after running the script once. When
    namespaced, they are in the form of `__dko_function_name()`.
- **Function bodies**
  - Never use the `fn() ( subshell body in parentheses )` format, always use
    curly braces first for consistency: `fn() { ( subshell body ); }`.
- **Variable interpolation**
  - Always use curly braces around the variable name when interpolating in
    double quotes.
- **Variable names**
  - Stick to nouns, lower camel case
- **Variable scope**
  - Use `local` and `readonly` variables as much as possible over
    global/shell-scoped variables.
- **Comparison**
  - Not strict on POSIX (e.g. assume my interactive shells are at least BASH)
  - Do NOT use BASH arrays, use Zsh or Python if need something complicated
  - Use BASH `==` for string comparison
  - Use BASH `(( A == 2 ))` for integer comparison (note not `$A`, `$` not
    needed)

