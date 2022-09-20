<div align="center">

# asdf-ecsk [![Build](https://github.com/t1732/asdf-ecsk/actions/workflows/build.yml/badge.svg)](https://github.com/t1732/asdf-ecsk/actions/workflows/build.yml) [![Lint](https://github.com/t1732/asdf-ecsk/actions/workflows/lint.yml/badge.svg)](https://github.com/t1732/asdf-ecsk/actions/workflows/lint.yml)


[ecsk](https://github.com/t1732/ecsk) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)

# Dependencies

- `bash`, `curl`, `tar`, `go`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add ecsk https://github.com/t1732/asdf-ecsk.git
```

ecsk:

```shell
# Show all installable versions
asdf list-all ecsk

# Install specific version
asdf install ecsk latest

# Set a version globally (on your ~/.tool-versions file)
asdf global ecsk latest

# Now ecsk commands are available
ecsk --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.
