
# Helper utilities for dealing with file paths and other file system related tasks
# https://github.com/ajgorhoe/IGLib.modules.IGLibScriptsPS.git



#Auxiliary variables - enable verification in the calling script:
$ScriptHasRun_File = $true
$ScriptDirectory_File = $PSScriptRoot


# Auxiliary definitions:
Set-Alias print Write-Host
Set-Alias alias Set-Alias
Set-Alias aliases Get-Alias
Set-Alias ScripttDir GetScriptDirectory
Set-Alias CurrentDir GetCurrentDirectory
Set-Alias AbsolutePath GetAbsolutePath
Set-Alias FullPath GetAbsolutePath
Set-Alias DirExists DirectoryExists
Set-Alias ParentDir GetParentDirectory
Set-Alias RootDir GetRootDirectory

function GetScriptDirectory() { $PSScriptRoot }

function GetCurrentDirectory() { return $(Get-Location).Path }

function GetAbsolutePath($Path = $null)
{
	if ("$Path" -eq "") { $Path = "."; }
	return $(Resolve-Path "$Path").Path;
}

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



