#!/bin/bash
# Genera CHANGELOG.md agrupando los commits por tipo (Conventional Commits).
set -euo pipefail

{
    echo "# Changelog"
    echo ""
    echo "## [Unreleased]"
    echo ""

    FEATS=$(git log --format="%s" | grep -E "^feat" || true)
    FIXES=$(git log --format="%s" | grep -E "^fix" || true)
    DOCS=$(git log --format="%s" | grep -E "^docs" || true)
    BREAKING=$(git log --format="%s" | grep -E "!" || true)

    if [ -n "$FEATS" ]; then
        echo "### Features"
        echo "$FEATS" | sed 's/feat[(a-z:!/ )]*: /- /'
        echo ""
    fi
    if [ -n "$FIXES" ]; then
        echo "### Bug Fixes"
        echo "$FIXES" | sed 's/fix[(a-z:!/ )]*: /- /'
        echo ""
    fi
    if [ -n "$DOCS" ]; then
        echo "### Documentation"
        echo "$DOCS" | sed 's/docs[(a-z:!/ )]*: /- /'
        echo ""
    fi
    if [ -n "$BREAKING" ]; then
        echo "### BREAKING CHANGES"
        echo "$BREAKING" | sed 's/[a-z!(]*!: /- /'
        echo ""
    fi
} > CHANGELOG.md
