@echo off
setlocal enabledelayedexpansion

REM Master initialization script - 99_init_all.cmd
REM Finds and executes all DD_init_*.cmd scripts where DD are digits 00-98
REM This script itself (99_init_all.cmd) is excluded from execution

echo ========================================
echo Master Initialization Script
echo ========================================
echo Searching for DD_init_*.cmd scripts...
echo.

REM Check required tools
set missing_tools=0
where fd >nul 2>&1
if errorlevel 1 (
    echo [X] Required tool not found: fd
    set /a missing_tools+=1
)
where dos2unix >nul 2>&1
if errorlevel 1 (
    echo [X] Required tool not found: dos2unix
    set /a missing_tools+=1
)

if %missing_tools% gtr 0 (
    echo.
    echo ERROR: Please install the missing tool(s) listed above and try again.
    echo   - fd:       https://github.com/sharkdp/fd
    echo   - dos2unix: https://waterlan.home.xs4all.nl/dos2unix.html
    exit /b 1
)

fd -g "*.bsh" -x dos2unix

set script_count=0
set success_count=0
set fail_count=0

REM Create a temporary file to store sorted script list
set temp_file=%TEMP%\init_scripts_%RANDOM%.txt
if exist "%temp_file%" del "%temp_file%"

REM Find all matching .cmd scripts with pattern DD_init_*.cmd
REM where DD are two digits (00-98), excluding 99_init_all.cmd
for %%f in (0?_init_*.cmd 1?_init_*.cmd 2?_init_*.cmd 3?_init_*.cmd 4?_init_*.cmd 5?_init_*.cmd 6?_init_*.cmd 7?_init_*.cmd 8?_init_*.cmd 9?_init_*.cmd) do (
    REM Get first two characters to check if it's 99
    set filename=%%f
    set prefix=!filename:~0,2!
    
    if not "!prefix!"=="99" (
        echo %%f >> "%temp_file%"
    )
)

REM Check if temp file was created and has content
if not exist "%temp_file%" (
    echo No matching DD_init_*.cmd scripts found.
    goto :end
)

REM Check if file is empty
for %%A in ("%temp_file%") do set file_size=%%~zA
if %file_size% equ 0 (
    echo No matching DD_init_*.cmd scripts found.
    del "%temp_file%"
    goto :end
)

REM Sort the file
sort "%temp_file%" /o "%temp_file%"

REM Display found scripts
echo Found scripts:
set line_num=0
for /f "usebackq delims=" %%l in ("%temp_file%") do (
    set /a line_num+=1
    echo   !line_num!. %%l
)
echo.

REM Execute each script in order
for /f "usebackq delims=" %%s in ("%temp_file%") do (
    if exist "%%s" (
        set /a script_count+=1
        echo ========================================
        echo Executing [!script_count!]: %%s
        echo ========================================
        
        call "%%s"
        set exit_code=!errorlevel!
        
        if !exit_code! neq 0 (
            echo [X] Failed: %%s returned error code !exit_code!
            set /a fail_count+=1
        ) else (
            echo [+] Success: %%s completed
            set /a success_count+=1
        )
        echo.
    )
)

REM Clean up temp file
if exist "%temp_file%" del "%temp_file%"

REM Summary
echo ========================================
echo Execution Summary:
echo ========================================
echo   Total scripts: %script_count%
echo   Successful: %success_count%
echo   Failed: %fail_count%
echo ========================================

:end
if %fail_count% gtr 0 (
    echo.
    echo WARNING: Some scripts failed!
    exit /b 1
)

if %script_count% gtr 0 (
    echo.
    echo All initialization scripts completed successfully!
)
exit /b 0