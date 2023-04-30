
# Powershell info and helper utilities
# https://github.com/ajgorhoe/IGLib.modules.IGLibScripts.git

# Remark: make sure you have set the execution policy correctly, e.g. (as admin.):
#   Set-ExecutionPolicy RemoteSigned

#Auxiliary variables - enable verification in the calling script:
$ScriptHasRun_PowerShellInfo = $true
$ScriptDirectory_PowerShellInfo = $PSScriptRoot

# Auxiliary definitions:
Set-Alias print Write-Host
Set-Alias alias Set-Alias
Set-Alias aliases Get-Alias

function PowerShellInfo()
{
	Write-Host 'Version information ($PSVersionTable):'
	# Write-Host $PSVersionTable
	# $PSVersionTable
	$PSVersionTable | ft -AutoSize
}

function ArrayToString($ArrayVar = $null)
{
	if ("$ArrayVar" -eq "") { return "$null"; }
	foreach ($key in $dictionary.Keys) { 
		Write-Host "Key: $key    Value: $($dictionary[$key])" 
	} 
}

function DictionaryToString(DictVar = $null)
{
	if ("$DictVar" -eq "") { return "$null"; }
	foreach ($key in $dictionary.Keys) { 
		Write-Host "Key: $key    Value: $($dictionary[$key])" 
	} 
}

function RunWithPowerShell($Command)
{
	powershell.exe '#Command'
}

 
PowerShellInfo



