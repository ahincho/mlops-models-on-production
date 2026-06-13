# Compilation script for CheXpert AI LaTeX article
# Requires: MiKTeX with pdflatex

$ErrorActionPreference = "Stop"
$logFile = "compile.log"

function Invoke-Step {
    param([string]$label, [scriptblock]$cmd)
    Write-Host "$label" -ForegroundColor Cyan -NoNewline
    & $cmd *>> $logFile
    if ($LASTEXITCODE -ne 0) {
        Write-Host " FAILED" -ForegroundColor Red
        Write-Host "See $logFile for details." -ForegroundColor Yellow
        exit 1
    }
    Write-Host " OK" -ForegroundColor Green
}

# Clear previous log
Clear-Content $logFile -ErrorAction SilentlyContinue

Write-Host "Compiling Chest Xpert AI article" -ForegroundColor White

Invoke-Step "Pass 1 (pdflatex)"  { pdflatex -interaction=nonstopmode -synctex=1 main.tex }
Invoke-Step "Bibliography (bibtex)" { bibtex main }
Invoke-Step "Pass 2 (pdflatex)"  { pdflatex -interaction=nonstopmode -synctex=1 main.tex }
Invoke-Step "Pass 3 (pdflatex)"  { pdflatex -interaction=nonstopmode -synctex=1 main.tex }

# Clean auxiliary files
Write-Host "Cleaning auxiliary files" -ForegroundColor Cyan -NoNewline
Remove-Item -Force -ErrorAction SilentlyContinue *.aux, *.bbl, *.blg, *.fdb_latexmk, *.fls, *.log, *.out, *.run.xml, *.synctex.gz, *.toc, *.lof, *.lot

Write-Host "Done! Output: main.pdf" -ForegroundColor Green
