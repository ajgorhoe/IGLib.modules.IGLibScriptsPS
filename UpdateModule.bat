
@echo off
setlocal

set InitialDir = %CD%
set ScriptDir=


echo.
echo Updating module %CheckoutDir%
echo   in:     %ScriptDir%
echo   repo:   %RepositoryAddress%
echo   branch: %CheckoutBranch%
echo.

if not defined ScriptDir (
  echo ERROR: ScriptDir not defined!
  echo.
  goto finalize
)

if not defined RepositoryAddress (
  echo ERROR: RepositoryAddress not defined!
  echo.
  goto finalize
)

if not defined CheckoutBranch (
  echo ERROR: CheckoutBranch not defined!
  echo.
  goto finalize
)

rem See e.g.:
rem https://stackoverflow.com/questions/10312521/how-to-fetch-all-git-branches

cd %ScriptDir%

echo.
echo Initializing scripts/ directory...
echo   at: %ScriptDir%
echo.

if not exist "%CheckoutDir%\.git" (
  if exist "%CheckoutDir% (
    echo.
    echo WARNING: Directory already exists: 
	echo   %CheckoutDir%
	echo Operation may fail and you may need to remove the following dir.:
	echo   %ScriptDir%\%CheckoutDir%
	echo.
  )
  echo Repository not yet checked out, cloning the code...
  call git clone %RepositoryAddress% %CheckoutDir%
  call git remote add origin %RepositoryAddress%
  echo.
)

cd %CheckoutDir%
call git fetch --all
call git pull --all

if defined CheckoutBranch (
  call git checkout --track origin/%CheckoutBranch%
  call git pull
)



:finalize

cd %InitialDir%

endlocal

