#!/usr/bin/env bash

set -euo pipefail

printf '%s\n' '==> Repository files'
ruby scripts/validate_repository.rb

printf '%s\n' '==> GitHub Actions workflows'
actionlint -color
