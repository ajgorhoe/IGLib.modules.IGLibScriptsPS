
@echo off

:: Removes the repository at the specified location.
:: Usually used for reposiories that are embedded as full independent 
:: repositories rather than via submodules or some other Git mechanism.

:: Callinng this script has NO SIDE EFFECTS (the body is enclosed in
:: setlocal / endlocal block).

:: PARAMETERS of the script are obtained via environment variables:
::   ModuleDir: root directory of cloned Repository

:: One way to call the script is to set all environment variables
:: that define parameters of the update (see above), then call this
:: script to perform the update. A better way is to create a settings
:: script that sets all the required parameters, and call this script
:: via embedded calll mechanism simply by stating script path as parameter
:: when calling the script (the advantage is that scripts have no sde
:: effects (variables set or changed) that would propagate to the calling
:: environment). See below for explanation.

:: If any PARAMETERS are specified when calling the script, these are 
:: interpreted as EMBEDDED COMMAND with parameters, which is CALLED
:: BEFORE the body of the current script is executed, still WITHIN setlocal
:: / endlocal block.
:: This mechanism makes possible to define as parameter a script that sets
:: all the parameters as environment variables (the settings script), which
:: is called before the body of this script is executed. The advantage of
:: this approach is that settings for different repositories are packed into
:: the corresponding settings scripts and handling different repositories
:: is performed by calling the current script wih the appropriate settings
:: script as parameter. Annother advantage is that the calling environment
:: is not polluted with environment variables defining the parameters,
:: because this script takes care (by defining setlocal/endlocal block) that
:: variables set in the embedded call do not propagate to the callerr's 
:: environment.

:: As EXAMPLE, suppose we define the scrippt SettingsRepoIGLibCore, which
:: contains repository settings for the IGLibCore repository. Removing the
:: corresponding repository is done simply by calling:

::   RemoveRepo.bat SettingsRepoIGLibCore.bat

:: It is advisable that the settings script is also created in such a way
:: that it can take an embedded script as parameter, and this script is 
:: run AFTER the environment variables (parameters for this script) are
:: set. In this way, some parameters can be simply overriden by recursively
:: nested commands, e.g.:
::   RemoveRepo.bat SettingsRepoIGLibCore.bat SetVar ModuleDir .\MyDir
:: This would cause the same as command with a single parameter, except that
:: the module's cloned directory would be different, i.e. instead of the 
:: branch specified in SettingsRepoIGLibCore.bat.


setlocal

:: Reset the error level (by running an always successfull command):
ver > nul
:: Base directories:
set ScriptDirUpdateRepo=%~dp0
set InitialDirUpdateRepo=%CD%

if "%~1" EQU "" goto AfterCommandCall
	:: If any command-line arguments were specified then assemble a 
	:: command-line from these arguments and execute it:

	:: Assemble command-line from the remaining arguments....
	set CommandLine6945="%~1"
	:loop
	shift
	if [%1]==[] goto afterloop
	set CommandLine6945=%CommandLine6945% "%~1"
	goto loop
	:afterloop

	:: Call the assembled command-line:
	call %CommandLine6945%
:AfterCommandCall


:: Print values of parameters relevant for repo updates/clone:
call  %~dp0\PrintRepoSettings.bat


:: Basic checks if something is forgotten
rem if not defined Remote (set Remote=origin)
rem if "%Remote%" EQU "" (set Remote=origin)
rem if not defined RemoteSecondary (set RemoteSecondary=originSecondary)
rem if "%RemoteSecondary%" EQU "" (set RemoteSecondary=originSecondary)
rem if not defined RemoteLocal (set RemoteLocal=local)
rem if "%RemoteLocal%" EQU "" (set RemoteLocal=local)

:: Derived parameters:
set ModuleGitSubdir=%ModuleDir%\.git\refs
echo Subdirectory identifying module correctness:
echo   "%ModuleGitSubdir%"
echo.

:: Defaults for eventually missing information:
set IsDefinedCheckoutBranch=0
if defined CheckoutBranch (
  if "%CheckoutBranch%" NEQ "" (
    set IsDefinedCheckoutBranch=1
  )
)
if %IsDefinedCheckoutBranch% EQU 0 (
  echo.
  echo CheckoutBranch set to default - master
  set CheckoutBranch=master
)
set IsDefinedRemote=0
if defined Remote (
  if "%Remote%" NEQ "" (
    set IsDefinedRemote=1
  )
)
if %IsDefinedRemote% EQU 0 (
  echo.
  echo Remote set to default - origin
  set Remote=origin
)

set IsDefinedRepositoryAddressSecondary=0
if defined RepositoryAddressSecondary (
  if "%RepositoryAddressSecondary%" NEQ "" (
    set IsDefinedRepositoryAddressSecondary=1
  )
)
if %IsDefinedRepositoryAddressSecondary% NEQ 0 (
    echo.
    echo Secondary repository address: %RepositoryAddressSecondary%
    echo.
) else (
    echo.
    echo Secondary repository address is not defined.
)
set IsDefinedRepositoryAddressLocal=0
if defined RepositoryAddressLocal (
  if "%RepositoryAddressLocal%" NEQ "" (
    set IsDefinedRepositoryAddressLocal=1
  )
)
if %IsDefinedRepositoryAddressLocal% NEQ 0 (
    echo.
    echo Local repository address: %RepositoryAddressLocal%
    echo.
) else (
    echo.
    echo Local repository address is not defined.
)

set IsDefinedRepositoryAddressSecondary=0
if defined RepositoryAddressSecondary (
  if "%RepositoryAddressSecondary%" NEQ "" (
    set IsDefinedRepositoryAddressSecondary=1
  )
)
if %IsDefinedRepositoryAddressSecondary% NEQ 0 (
    echo.
    echo Secondary repository address: %RepositoryAddressSecondary%
    echo.
) else (
    echo.
    echo Secondary repository address is not defined.
)

set IsClonedAlready=0
if exist "%ModuleGitSubdir%" (
    set IsClonedAlready=1
)

echo.
echo.
echo Removing (embedded) repository located at:
echo   "%ModuleDir%"
echo.

:: Clone the repo if one does not exist (remove its directory before):
if not exist "%ModuleGitSubdir%" (
  echo.
  echo Module Git subdirectory does not exist:
  echo   "%ModuleGitSubdir%"
  echo Removing of module directory will not be performed.
  echo.  
  if exist "%ModuleDir%" (
    :: Warn about existing module directory:
    echo.
    echo Module directory exists however:
	echo   "%ModuleDir%"
	echo If the above directory was intended to be remove, please REMOVE it
	echo   MANUALLY!
    echo Executing:
    echo   rd /s /q "%ModuleDir%"
    rd /s /q "%ModuleDir%"
    echo.
  )
) else (
    rem 
)

echo.
echo REMOVING Module directory:
echo   "%ModuleDir%"
echo Executing:
echo   rd /s /q "%ModuleDir%"
call rd /s /q "%ModuleDir%"
echo.



:finalize

cd %InitialDirUpdateRepo%
ver > nul

echo.
echo Calling endlocal before completing the script...

endlocal

echo   ... done, script completed.

