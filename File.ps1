
# Helper utilities for dealing with file paths and other file system related tasks
# https://github.com/ajgorhoe/IGLib.modules.IGLibScriptsPS.git



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

CheckScriptExecuted $ExecutedScriptPath_File $MyInvocation.MyCommand.Path;

#Auxiliary variables - enable verification in the calling script:
$ExecutedScriptPath_File = $MyInvocation.MyCommand.Path

# Auxiliary definitions:
Set-Alias print Write-Host
Set-Alias alias Set-Alias
Set-Alias aliases Get-Alias
Set-Alias ScripttDir GetScriptDirectory
Set-Alias CurrentDir GetCurrentDirectory
Set-Alias FullPath GetAbsolutePath
Set-Alias DirExists DirectoryExists
Set-Alias AbsolutePath GetAbsolutePath
Set-Alias FileName GetFileName
Set-Alias GetFileOrDirectoryName GetFileName
Set-Alias ParentDir GetParentDirectory
Set-Alias RootDir GetRootDirectory

function GetScriptDirectory() { $PSScriptRoot }

function GetCurrentDirectory() { return $(Get-Location).Path }

function DirectoryExists(<#[system.string]#> $DirectoryPath = $null)
{
	if ("$DirectoryPath" -eq "") { return $false; }
	return Test-Path "$DirectoryPath" -PathType Container
}

function FileExists(<#[system.string]#>  $FilePath = $null)
{
	if ("$FilePath" -eq "") { return $false; }
	return Test-Path "$FilePath" -PathType Leaf
}

function PathExists($Path = $null)
{
	if ("$Path" -eq "") { return $false; }
	return Test-Path "$Path"
}

function GetAbsolutePath($Path = $null)
{
	if ("$Path" -eq "") { $Path = "."; }
	return $(Resolve-Path "$Path").Path;
}

function GetFileName($Path = ".")
{
	if ("$Path" -eq "") { $Path = "." }
	if (PathExists($Path))
	{
		$Path = GetAbsolutePath($Path);
	}
	return Split-Path "$Path" -Leaf
}

function GetParentDirectory($Path = ".")
{
	if ("$Path" -eq "") { $Path = "." }
	if (PathExists($Path))
	{
		return Split-Path "$Path" -Resolve
	}
	return Split-Path "$Path"
}

function GetRootDirectory($Path = $null, $ChildPath = $null)
{
#	print GetRootDirectory called with:
#	print "  Path: $Path"
#	print "  ChildPath: $ChildPath"
	if ("$Path" -eq "" -and "$ChildPath" -eq "") { $Path = "."; }
	if ($(PathExists("$Path")) -or $true)
	{
		$ParentPath = GetParentDirectory($Path);
#		print "Path: $Path"
#		print "ParentPath: $ParentPath"
		if ("$ParentPath" -eq "")  {
			return $Path; 
		}
#		print "Calling: GetRootDirectory($ParentPath, $Path)";
		return GetRootDirectory $ParentPath $Path
	} else
	{
		return $null;
	}
}



