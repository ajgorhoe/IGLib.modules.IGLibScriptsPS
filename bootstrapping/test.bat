
@echo off

:: Tests the BootStrapScripting.bat
::
:: Scripts are executed in setlocal/endlocal block such that there are not
:: side effects on callind context's environment variables.
::
:: All arguments are passed to the called scripts.
:: 
:: After calling the script, environment variables containing script paths 
:: and nvironment variables containing settings for IGLib repository are
:: printed out for easier debugging abd troubleshooting.

setlocal
call "%~dp0\BootStrapScripting.bat" %*

call %PrintRepoSettings%
call %PrintScriptReferences%
endlocal

:finalize


