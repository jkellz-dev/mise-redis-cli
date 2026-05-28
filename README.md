<div align="center">

# asdf-redis-cli [![Build](https://github.com/NeoHsu/asdf-redis-cli/actions/workflows/build.yml/badge.svg)](https://github.com/NeoHsu/asdf-redis-cli/actions/workflows/build.yml) [![Lint](https://github.com/NeoHsu/asdf-redis-cli/actions/workflows/lint.yml/badge.svg)](https://github.com/NeoHsu/asdf-redis-cli/actions/workflows/lint.yml)

[redis-cli](https://redis.io/topics/rediscli) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
  - [Version selection](#version-selection)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, `make`, a C compiler such as `gcc`, OpenSSL development headers, and
  [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).

# Install

Plugin:

```shell
asdf plugin add redis-cli
# or
asdf plugin add redis-cli https://github.com/NeoHsu/asdf-redis-cli.git
```

redis-cli:

```shell
# Show all installable versions
asdf list all redis-cli

# Install the latest stable redis-cli
asdf install redis-cli latest

# Set a version for your user (writes to your ~/.tool-versions)
asdf set -u redis-cli latest

# Now redis-cli commands are available
redis-cli --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

## Version selection

`latest` resolves to the newest stable Redis source release and skips beta/rc/milestone releases.

```shell
# Latest stable release
asdf install redis-cli latest

# Latest stable release in a version series
asdf install redis-cli latest:8.6

# Specific release
asdf install redis-cli 8.8.0
```

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

Testing Locally:

```shell
asdf plugin test redis-cli https://github.com/NeoHsu/asdf-redis-cli.git "redis-cli --version" --asdf-tool-version latest
```

[Thanks goes to these contributors](https://github.com/NeoHsu/asdf-redis-cli/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Neo Hsu](https://github.com/NeoHsu/)
