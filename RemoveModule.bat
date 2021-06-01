
@echo off
setlocal

if defined ScriptDir (
  if "%ScriptDir%" NEQ "" (
    rem Store eventual directory of the calling script to use it in settings:
    set CallingScriptDir=%ScriptDir%
  )
)
set InitialDir = %CD%
set ScriptDir=%~dp0
set SettingsScriptName=Settings_UpdateModule.bat
set SettingsScript=%ScriptDir%%SettingsScriptName%
rem Reset error information (undefine aux. variables):
set StoredErrorLevel=
set ErrorMessage=

echo.
echo.
echo ====
echo.
rem Take into account command-line arguments:
if "%~1" NEQ "" (
  if defined ModuleDir (
    if "%ModuleDir%" NEQ "%~1%" (
      echo %0:
      echo ModuleDir overridden by command-line argument:
      echo   %ModuleDir%
      echo   replaced by:
      echo   %~1%
      echo.
	)
	echo Module directory not defined, set to arg. 1.
  )
  set ModuleDir=%~1
)

rem Do some verifications:
if not defined ModuleDir (
  echo Module direcory NOT DEFINED, exiting...
  set StoredErrorLevel=1
  set ErrorMessage=Module's directory is not defined.
  goto finalize
)
set ModuleGitDir=%ModuleDir%\.git\
if not exist "%ModuleGitDir%" (
  echo Module direcory NOT PROPER Git DIRECTORY, exiting...
  set StoredErrorLevel=1
  set ErrorMessage=Module's directory is not a Git directory.
  goto finalize
)

if exist ModuleDir (
  echo REMOVING Module directory:
  echo   "%ModuleDir%"
  echo Executing:
  echo   rd /s /q "%ModuleDir%"
  call dir .
)


:finalize

rem Output the settings used, if specified by env. variable:
if defined PrintSettingsInScripts (
  if %% NEQ 0 (
    echo.
    echo _____________________________________
    echo Module REMOVAL script - SETTINGS used:
    call %ScriptDir%PrintSettings_UpdateModule.bat %*
    echo _____________________________________
    echo.
  )
)


rem Error reporting:
set IsDefinedStoredErrorLevel=0
if defined StoredErrorLevel (
  if %StoredErrorLevel% NEQ 0 (
	set ERRORLEVEL=%StoredErrorLevel%
	set IsDefinedStoredErrorLevel=1
  ) else (
    rem Undefine if 0:
    set StoredErrorLevel=
  )
)
if %ERRORLEVEL% EQU 0 (
  echo Remove module completed successfully.
) else (
  echo.
  echo An ERROR occurred in %0:
  if %IsDefinedStoredErrorLevel% NEQ 0 (
    echo   StoredErrorLevel = %StoredErrorLevel%
  ) else (
    echo ERRORLEVEL: %ERRORLEVEL%
  )
  if defined ErrorMessage (
    if "%ErrorMessage%" NEQ "" (
      echo   Error message: %ErrorMessage%
	)
  )
  echo.
  if %IsDefinedStoredErrorLevel% NEQ 0 (
    rem Also properly propagate error level to the calling environment:
    exit /b %StoredErrorLevel%
  )
)


rem restore current directory and environment to state before the call:
cd %InitialDir%
endlocal



