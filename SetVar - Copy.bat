
@echo off
:: This script sets the variable whose name is derived from its first argument to the
:: value specified by the second argument of the script.
:: AFTER setting the variable, if there are more arguments, the script treats the rest
:: of the arguments as command with parameters and executes it. This can propagate 
:: RECURSIVELY, therefore the following command would set both variables a and b:
::   SetVar a 22 SetVar b 33

:: Examples:
:: This sets variable a to xx:
::   SetVar a xx
:: This sets variable a to value "123 xyz" (without quotes):
::   SetVar a "123 xyz"
:: The value must be in quotes in this case, otherwise 123 and xyz would be treated
:: as two arguments, value would be set to 123, and xyz would be treated as command 
:: to be called recursively.

:: The following would set variable cc to XXYY, then variable bb to "11 12", and finally 
:: variable aa to "123 xyz" (all values without quotes). This is because the ::aining 
:: arguments after the second one are treated as another command that is called after setting
:: the variable, and this is don twoce recursively in this case:
::   SetVar aa "123 xyz" SetVar bb "11 12" SetVar cc XXYY


echo Setting variable %~1 to value: %~2
call set %~1=%~2


    :: echo.
    :: echo SetVar: Executing embedded after-commnd specified by arguments:
    :: echo   call "%~3" "%~4" "%~5" "%~6" "%~7" "%~8" "%~9"
    :: call "%~3" "%~4" "%~5" "%~6" "%~7" "%~8" "%~9"


:: Skip the first two arguments that were consummed vor seting a variable:
shift
shift

if "%~1" EQU "" goto finalize
:: If more command-line arguments were specified then form another 
:: command-line and execute it:

:: :: Assign the first remaining argument as recursive command...
:: set CommandName6945=%~1
:: shift

:: echo.
:: echo Form command-line args from remaining arguments....
set CommandLine6945="%~1"
:loop
shift
:: echo in the loop after shift, %%1 = %1
if [%1]==[] goto afterloop
set CommandLine6945=%CommandLine6945% "%~1"
goto loop
:afterloop

:: echo.
:: echo After forming command-line:
:: echo CommandName6945:     %CommandName6945%
:: echo CommandLine6945 : %CommandLine6945%

:: echo.
:: echo Calling the assembled command-line:
:: echo calling: 
:: echo   call %CommandLine6945%
call %CommandLine6945%

:: echo   call "%CommandName6945%" %CommandLine6945%
:: call "%CommandName6945%" %CommandLine6945%



:finalize

ver > nul

