
# Common utilities used in other scripts.
# https://github.com/ajgorhoe/IGLib.modules.IGLibScriptsPS.git


# Internal use.
# Checks whether the specified script has already run, by using the variable
# where the script stores its location, and the current location of the script.
# If the script has already been executed, an informative message is printed to
# the standard output.
# $NotedScriptPath: must be set to the script path stored in a variable by the script.
# $ScriptPath: Must be set to actual path of the current script.
function CheckScriptExecuted($NotedScriptPath, $ScriptPath)
{
	if ("$NotedScriptPath" -eq "") { return; }
	$ScriptFile = $(Split-Path "$ScriptPath" -Leaf)
	if ("$NotedScriptPath" -ne "")
	{
		if (  "$((Resolve-Path($NotedScriptPath)).Path)" -eq
			"$(Resolve-Path($ScriptPath))" )
		{
			Write-Host "`nThe script has already been executed, refreshing definitions: $ScriptFile`n"
		} else
		{
			Write-Host "`nWarning: Script has already been called from a different location: $ScriptFile"
			Write-Host "Previous location: $NotedScriptPath"
			Write-Host "Current location:  $ScriptPath`n"
		}
	}
}

CheckScriptExecuted $ExecutedScriptPath_Common $MyInvocation.MyCommand.Path;

# Store scritp path in a variable in order to enable later verifications:
$ExecutedScriptPath_Common = $MyInvocation.MyCommand.Path

# Auxiliary definitions:
Set-Alias print Write-Host
Set-Alias alias Set-Alias
Set-Alias aliases Get-Alias


