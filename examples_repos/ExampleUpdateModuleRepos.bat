
@echo off

rem Example: cloning or updating module repositories..

setlocal

rem Reset the error level (by running an always successfull command):
ver > nul

set ScriptDir=%~dp0
set InitialDir=%CD%
set UpdateScript=%ScriptDir%\..\UpdateRepo.bat

echo.
echo Updating IGLib modules...
echo   ScriptDir: %ScriptDir%
echo   UpdateScript: %UpdateScript%
echo.

call "%UpdateScript%" "%ScriptDir%ExampleSettingsIGLibScripts.bat"
rem call "%UpdateScript%" "%ScriptDir%ExampleSettingsIGLibCore.bat"

endlocal

