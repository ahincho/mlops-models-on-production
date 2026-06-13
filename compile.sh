#!/usr/bin/env bash
# Compilation script for CheXpert AI LaTeX article
# Requires: pdflatex + bibtex (TeX Live or MiKTeX)

set -e

LOG="compile.log"
> "$LOG"  # Clear previous log

step() {
    local label="$1"
    shift
    printf "%-30s" "$label"
    "$@" >> "$LOG" 2>&1
    echo "OK"
}

echo ""
echo "Compiling Chest Xpert AI article"

step "Pass 1 (pdflatex)"      pdflatex -interaction=nonstopmode -synctex=1 main.tex
step "Bibliography (bibtex)"  bibtex main
step "Pass 2 (pdflatex)"      pdflatex -interaction=nonstopmode -synctex=1 main.tex
step "Pass 3 (pdflatex)"      pdflatex -interaction=nonstopmode -synctex=1 main.tex

echo "Cleaning auxiliary files"
rm -f *.aux *.bbl *.blg *.fdb_latexmk *.fls *.log *.out *.run.xml *.synctex.gz *.toc *.lof *.lot

echo ""
echo "Done! Output: main.pdf"
echo ""
