

# Auxiliary definitions:
Set-Alias print Write-Host
Set-Alias alias Set-Alias
Set-Alias aliases Get-Alias
alias ScripttDir GetScriptDirectory
alias CurrentDir GetCurrentDirectory
alias DirExists DirectoryExists
alias ParentDir GetParentDirectory
aias RootDir GetRootDirectory

function GetScriptDirectory() { $PSScriptRoot }

function GetCurrentDirectory() { return $(pwd).Path }

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

function GetParentDirectory($Path = $null)
{
	if ("$Path" -eq "") { return $false; }
	if (PathExists($Path))
	{
		return Split-Path "$Path" -Resolve
	}
	return Split-Path "$Path"
}

function GetRootDirectory($Path = $null)
{
	if ("$Path" -eq "") { $Path = "."; }
	if (PathExists($Path))
	{
		return Split-Path "$Path" -Resolve
	}
	return Split-Path "$Path"
}



