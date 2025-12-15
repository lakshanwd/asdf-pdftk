<div align="center">

# asdf-pdftk [![Build](https://github.com/lakshanwd/asdf-pdftk/actions/workflows/build.yml/badge.svg)](https://github.com/lakshanwd/asdf-pdftk/actions/workflows/build.yml) [![Lint](https://github.com/lakshanwd/asdf-pdftk/actions/workflows/lint.yml/badge.svg)](https://github.com/lakshanwd/asdf-pdftk/actions/workflows/lint.yml)

[pdftk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add pdftk https://github.com/lakshanwd/asdf-pdftk.git
```

For pre-0.16.0 asdf versions:

```shell
asdf plugin-add pdftk https://github.com/lakshanwd/asdf-pdftk.git
```

pdftk:

```shell
# Show all installable versions
asdf list all pdftk

# Install specific version
asdf install pdftk latest

# Set a version globally (on your ~/.tool-versions file)
asdf set -u pdftk latest

# Now pdftk commands are available
pdftk --version
```

For pre-0.16.0 asdf versions:

```shell
# Show all installable versions
asdf list-all pdftk

# Install specific version
asdf install pdftk latest

# Set a version globally (on your ~/.tool-versions file)
asdf global pdftk latest

# Now pdftk commands are available
pdftk --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/lakshanwd/asdf-pdftk/graphs/contributors)!

# License

See [Apache 2.0](LICENSE) © [Lakshan Dissanayake](https://github.com/lakshanwd/)
