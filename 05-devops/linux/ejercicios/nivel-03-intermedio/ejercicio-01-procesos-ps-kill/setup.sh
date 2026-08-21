#!/usr/bin/env bash
set -euo pipefail
# No requiere setup especial: el script del usuario lanza y mata procesos.
: "${1:-$(pwd)}"
