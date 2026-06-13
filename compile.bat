@echo off
REM Compile LaTeX document with bibliography
pdflatex -interaction=nonstopmode main.tex
bibtex main
pdflatex -interaction=nonstopmode main.tex
pdflatex -interaction=nonstopmode main.tex
echo.
echo Compilation complete: main.pdf
pause
