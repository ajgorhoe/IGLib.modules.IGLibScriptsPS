

# Auxiliary definitions:
set-alias print Write-Host


function ScriptDir() { $PSScriptRoot }

function CurrentDir() { return $(pwd).Path }

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

function ParentDir($Path = $null)
{
	if ("$Path" -eq "") { return $false; }
	if (PathExists($Path))
	{
		return Split-Path "$Path" -Resolve
	}
	return Split-Path "$Path"
}

function RootDir($Path = $null)
{
	if ("$Path" -eq "") { return $false; }
	if (PathExists($Path))
	{
		return Split-Path "$Path" -Resolve
	}
	return Split-Path "$Path"
}



