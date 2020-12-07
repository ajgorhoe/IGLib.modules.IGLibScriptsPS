
@echo off
rem Start local context, such that generation script does not have side effects:
setlocal
set StoredErrorLevel=0
rem Reset the error level (by running an always successfull command):
ver > nul

set RepositoryAddress=https://gitlab.com/ajgorhoe/iglib.workspace.scripts.git
rem https://gitlab.com/ajgorhoe/iglib.workspace.codedoc_develop.git
set CheckoutDir=scripts
set CheckoutBranch=master

set ScriptDir=%~dp0
set InitialDir=%CD%

cd %ScriptDir%

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


cd %InitialDir%


