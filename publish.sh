#!/bin/bash
# ============================================================
# publish.sh — render the book and push it to BOTH live sites.
#
#   ./publish.sh
#
# Publishing to both from one command is deliberate: two live URLs
# means one silently goes stale if you update them separately.
#
# NOTE: --to html is intentional. _quarto.yml also declares a pdf
# format, but that leg currently fails on a missing LaTeX package
# (tabularray.sty). Rendering html only keeps publishing unblocked.
# If you fix the PDF later, drop the "--to html".
#
# This repo (~/Desktop/GitHub/BIOS526_Book) is the SOURCE OF TRUTH.
# The copy under OneDrive/BIOS 526/ is a stale duplicate — editing it
# is what caused the Aug 2026 divergence. Do not edit both.
# ============================================================
set -euo pipefail
cd "$(dirname "$0")"

# Quarto ships inside RStudio; it is not on the default PATH.
export PATH="/Applications/RStudio.app/Contents/Resources/app/quarto/bin:$PATH"

echo "==> rendering (html)"
quarto render --to html

echo "==> publishing to GitHub Pages"
quarto publish gh-pages --no-render --no-prompt --no-browser

echo "==> publishing to Quarto Pub"
quarto publish quarto-pub --no-render --no-prompt --no-browser

echo
echo "==> done. Both sites updated."
echo "    https://enpeterson.github.io/BIOS526_Book/"
echo "    (Quarto Pub URL is recorded in _publish.yml)"
