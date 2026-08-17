#!/bin/bash
# ============================================================
# publish.sh — render the book and update the live site.
#
#   ./publish.sh
#
# The live site students reach from Canvas:
#   https://Enpeterson.github.io/BIOS526_Book/
#
# Run this from THIS repo (~/Desktop/GitHub/BIOS526_Book) only. The copy
# under OneDrive/BIOS 526/ is a manual mirror with no git remote —
# publishing from there cannot work, and editing both is what caused the
# Aug 2026 divergence.
# ============================================================
set -euo pipefail
cd "$(dirname "$0")"

# Quarto ships inside RStudio; it is not on the default PATH.
export PATH="/Applications/RStudio.app/Contents/Resources/app/quarto/bin:$PATH"

echo "==> rendering"
quarto render

echo "==> publishing to GitHub Pages"
quarto publish gh-pages --no-render --no-prompt --no-browser

# Optional second mirror. Quarto Pub needs a one-time interactive login
# ("quarto publish quarto-pub" in a real Terminal) before this can work,
# so a failure here is not fatal — GitHub Pages is the site of record.
if grep -q "quarto-pub" _publish.yml 2>/dev/null; then
  echo "==> publishing to Quarto Pub"
  quarto publish quarto-pub --no-render --no-prompt --no-browser || \
    echo "    (Quarto Pub push failed — GitHub Pages above is still updated)"
else
  echo "==> Quarto Pub not configured, skipping (GitHub Pages is the live site)"
fi

echo
echo "==> done: https://Enpeterson.github.io/BIOS526_Book/"
echo "    GitHub Pages takes a minute or two; hard-refresh if you see the old version."
