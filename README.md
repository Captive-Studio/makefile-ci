# Makefile CI module

[![License][license-image]][license-url]

> Default makefile workflow for continuous integration local and remote (GitlabCI, CircleCI, etc)

## Purpose

This package provides a collection of makefiles that should be included in a project as git module (using [makefile-core](https://github.com/Captive-Studio/makefile-core))

These makefiles are designed to _standardize_ and _simplify_ the workflow to `build`, `run` and `deploy` the project.

As a result, the developer only has to learn a restricted set of command (ex: `make help`, `make build`, `make test`) to manipulate the project without the need to know about the underlying stack.

## Features

- 🔧 Zero Conf philosophy
  - ✓ Auto detect stack from project source code (ex: `package.json` for NodeJS, `Gemfile` for ruby, etc)
  - ✓ Almost everything should work with very few configuration for the most common cases
  - ✓ Everything should be overridable in `config.mk` or `Makefile` if needed
- 💡 Use simple `make` targets for better productivity
  - Generic target will run the equivalent task in every language used by the project (ex: `make lint` will run `npm run lint`, `bundle exec rubocop`, etc)
  - No more "I forgot to do `bundle install`, `asdf install`, etc", `make` will do it for you in a performant way 
- 💻 Support local and CI environment (with `CI` environment variable)
- 👍 Supported technologies :
  - ✓ NodeJS
  - ✓ Ruby
  - ✓ Docker
- 🤖 CI friendly !
  - 🔧 Easy configuration : create a job per target (lint => `make lint`, test => `make test`, etc)
  - 🐛 Easy debugging (just run `CI=1 make xxxx` locally to reproduce locally the CI command)
  - 👍 Supported CI provider
    - CircleCI
- 🚀 Deploy target
  - Scalingo
  - Heroku
  - (More coming)

## Getting started

### 1. Installation

#### Step 1 : Install makefile-core

```console
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Captive-Studio/makefile-core/main/install.sh)"
```

source: [Makefile Core](https://github.com/Captive-Studio/makefile-core)

#### Step 2 : Install makefile-ci

```console
make self-add url=https://github.com/Captive-Studio/makefile-ci
```

#### Step 3 : Verification

```console
make help
```

### 2. Make configuration

`<project_root>/config.mk`
```make
# Put here variables
SCALINGO_APP_PREFIX ?= my-special-prefix-
```

### 3. CI configuration

#### CircleCI

```console
make .circleci/config.yml
```

## Usage

### `make help` : Display all targets and variables

```shell
make help
```

### `make print-variables` : Display all variables and their value

```shell
make print-variables
```

### `CI=1 make {{target}}` : Run in CI mode locally (for debugging)

To toggle mode use `CI` environment variable. This variable is already set in most CI provider (CircleCI, GitlabCI, etc).
As a consequence `make {{target}}` will automatically change mode when launched in local or in CI environment.

Nevertheless it possible to run locally in CI mode :

```shell
# WARNING : recommended for debugging purpose only
CI=1 make lint
```

## Contributing

TODO

## Acknowledgement

TODO

## License
<!-- AUTO-GENERATED-CONTENT:START (PKG_JSON:template=[${license}][license-url] © ${author}) -->
[MIT][license-url] © Captive Studio
<!-- AUTO-GENERATED-CONTENT:END -->

<!-- VARIABLES -->

<!-- AUTO-GENERATED-CONTENT:START (PKG_JSON:template=[package-version-svg]: https://img.shields.io/npm/v/${name}.svg?style=flat-square) -->
<!-- AUTO-GENERATED-CONTENT:END -->
<!-- AUTO-GENERATED-CONTENT:START (PKG_JSON:template=[package-url]: https://www.npmjs.com/package/${name}) -->
<!-- AUTO-GENERATED-CONTENT:END -->
<!-- AUTO-GENERATED-CONTENT:START (PKG_JSON:template=[license-image]: https://img.shields.io/badge/license-${license}-green.svg?style=flat-square) -->
[license-image]: https://img.shields.io/badge/license-MIT-green.svg?style=flat-square
<!-- AUTO-GENERATED-CONTENT:END -->
[license-url]: ./LICENSE
