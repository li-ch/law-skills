@echo off
setlocal enabledelayedexpansion

REM new-paper.bat — bootstrap a new academic paper repository (Windows)
REM Usage: new-paper.bat --name <name> --venue <venue> --year <year> [--cycle <cycle>]

set NAME=
set VENUE=
set YEAR=
set CYCLE=

:parse_args
if "%~1"=="" goto validate
if "%~1"=="--name"   (set NAME=%~2   & shift & shift & goto parse_args)
if "%~1"=="--venue"  (set VENUE=%~2  & shift & shift & goto parse_args)
if "%~1"=="--year"   (set YEAR=%~2   & shift & shift & goto parse_args)
if "%~1"=="--cycle"  (set CYCLE=%~2  & shift & shift & goto parse_args)
echo Unknown argument: %~1
exit /b 1

:validate
if "%NAME%"=="" (echo ERROR: --name is required & exit /b 1)
if "%VENUE%"=="" (echo ERROR: --venue is required & exit /b 1)
if "%YEAR%"=="" (echo ERROR: --year is required & exit /b 1)

set SCRIPT_DIR=%~dp0
set SKILL_DIR=%SCRIPT_DIR%..
set TEMPLATE_DIR=%SKILL_DIR%\assets\template
set VENUE_TEMPLATES_DIR=%SKILL_DIR%\assets\venue-templates
set COMMON_LAW=%USERPROFILE%\.common-law

REM Build directory name
if "%CYCLE%"=="" (
    set PAPER_DIR=%NAME%-%VENUE%-%YEAR%
) else (
    set PAPER_DIR=%NAME%-%VENUE%-%YEAR%-%CYCLE%
)

if exist "%PAPER_DIR%" (
    echo WARNING: Directory '%PAPER_DIR%' already exists.
    exit /b 1
)

echo Creating paper repository: %PAPER_DIR%

REM Copy template
xcopy /E /I /Q "%TEMPLATE_DIR%" "%PAPER_DIR%" > nul

REM Copy venue template files
if exist "%VENUE_TEMPLATES_DIR%\%VENUE%" (
    xcopy /Q "%VENUE_TEMPLATES_DIR%\%VENUE%\*" "%PAPER_DIR%\" > nul 2>&1
) else (
    echo WARNING: No template files found for venue '%VENUE%'
)

REM Copy shared files
if exist "%COMMON_LAW%\paper-style\CLAUDE.md" (
    copy /Y "%COMMON_LAW%\paper-style\CLAUDE.md" "%PAPER_DIR%\CLAUDE.md" > nul
) else (
    echo WARNING: %COMMON_LAW%\paper-style\CLAUDE.md not found.
)

if exist "%COMMON_LAW%\bib\refs.bib" (
    copy /Y "%COMMON_LAW%\bib\refs.bib" "%PAPER_DIR%\refs.bib" > nul
) else (
    echo WARNING: %COMMON_LAW%\bib\refs.bib not found.
)

REM Append narrative placeholder
>> "%PAPER_DIR%\CLAUDE.md" echo.
>> "%PAPER_DIR%\CLAUDE.md" echo ---
>> "%PAPER_DIR%\CLAUDE.md" echo.
>> "%PAPER_DIR%\CLAUDE.md" echo ## Paper Narrative
>> "%PAPER_DIR%\CLAUDE.md" echo *Fill in before writing.*
>> "%PAPER_DIR%\CLAUDE.md" echo.
>> "%PAPER_DIR%\CLAUDE.md" echo ### Research question
>> "%PAPER_DIR%\CLAUDE.md" echo [One sentence]
>> "%PAPER_DIR%\CLAUDE.md" echo.
>> "%PAPER_DIR%\CLAUDE.md" echo ### Challenges
>> "%PAPER_DIR%\CLAUDE.md" echo - [Challenge 1]
>> "%PAPER_DIR%\CLAUDE.md" echo.

REM Write AGENTS.md — simplified, Windows batch-safe version
(
echo # AGENTS.md — %NAME%
echo.
echo ## Paper metadata
echo - System name macro: \sys → [FILL IN]
echo - Venue: %VENUE% %YEAR%
echo - Page limit: [see venue-map]
echo - Active bib file: refs.bib
echo.
echo ## Build
echo - Use build.bat ^(Windows^)
echo - pdflatex engine only
echo.
echo ## Section structure
echo Fill in after writing sections.
echo.
echo ## LaTeX conventions
echo - Never modify existing macros or class/style files.
echo - Use \cref{} for all cross-references.
echo - Citation style: ~\cite{key}
echo - No emdashes, no hyphens in prose, no \textbf{} mid-paragraph.
echo.
echo ## Writing style
echo Read CLAUDE.md for the full writing guide.
) > "%PAPER_DIR%\AGENTS.md"

REM Initialize git
pushd "%PAPER_DIR%"
git init > nul 2>&1
git add -A > nul 2>&1
git commit -m "Initial commit: bootstrap %NAME% for %VENUE% %YEAR%" > nul 2>&1
popd

echo.
echo Paper repository created: %PAPER_DIR%
echo Next steps: fill in \sys, author macros, and Paper Narrative.
