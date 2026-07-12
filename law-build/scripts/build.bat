@echo off
setlocal

set MAIN=main
set TEMPDIR=temp
set LATEX=pdflatex
set BIBTEX=bibtex
set FLAGS=-output-directory=%TEMPDIR% -interaction=nonstopmode

if not exist %TEMPDIR% mkdir %TEMPDIR%

rem Detect bibtex requirement
findstr /C:"\\bibliography{" "%MAIN%.tex" >nul 2>&1
if %errorlevel% equ 0 (
    rem 4-pass
    echo [1/4] First pdflatex pass...
    %LATEX% %FLAGS% %MAIN%.tex
    if errorlevel 1 goto error

    echo [2/4] BibTeX pass...
    set BIBINPUTS=.
    %BIBTEX% %TEMPDIR%\%MAIN% 2>nul

    echo [3/4] Second pdflatex pass...
    %LATEX% %FLAGS% %MAIN%.tex
    if errorlevel 1 goto error

    echo [4/4] Third pdflatex pass...
    %LATEX% %FLAGS% %MAIN%.tex
    if errorlevel 1 goto error
) else (
    rem 3-pass
    echo [1/3] First pdflatex pass...
    %LATEX% %FLAGS% %MAIN%.tex
    if errorlevel 1 goto error

    echo [2/3] Second pdflatex pass...
    %LATEX% %FLAGS% %MAIN%.tex
    if errorlevel 1 goto error

    echo [3/3] Third pdflatex pass...
    %LATEX% %FLAGS% %MAIN%.tex
    if errorlevel 1 goto error
)

if not exist %TEMPDIR%\%MAIN%.pdf goto error

rem Build timestamp
for /f "tokens=2 delims==" %%i in ('wmic os get localdatetime /value') do set DT=%%i
set STAMP=%DT:~0,4%%DT:~4,2%%DT:~6,2%%DT:~8,2%%DT:~10,2%
set OUTPDF=%MAIN%-%STAMP%.pdf

copy /Y %TEMPDIR%\%MAIN%.pdf %OUTPDF% > nul

echo Done: %OUTPDF%
goto end

:error
echo BUILD FAILED. Check %TEMPDIR%\%MAIN%.log for details.
exit /b 1

:end
endlocal
