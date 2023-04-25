
$ScriptHasRun_GitHelpers = $true
$ScriptDirectory_GitHelpers = $PSScriptRoot


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

function IsGitRoot($DirectoryPath = $null)
{
	if ("$DirectoryPath" -eq "") { return $false; }
	$GitRefDirectoryName = ".git/refs"
	$GitRefDirectoryPath = $(Join-Path "$DirectoryPath" `
		"$GitRefDirectoryName")
	return Test-Path "$GitRefDirectoryPath" -PathType Container
}


function IsGitWorkingDirectory($DirectoryPath = $null)
{
	if ("$DirectoryPath" -eq "") { return $false; }
	if (IsGitRoot($DirectoryPath)) { return $true; }
	return IsGitWorkingDirectory $(GetParentDirectory("$DirectoryPath"))
}

function GetGitRoot($DirectoryPath = $null)
{
	if ("$DirectoryPath" -eq "") { return $null; }
	if (IsGitRoot($DirectoryPath)) { 
		return (Resolve-Path $DirectoryPath); }
	return GetGitRoot $(GetParentDirectory("$DirectoryPath"))
}


function IsGitWorkingDirectoryNotWorking($DirectoryPath = $null)
{
	if ("$DirectoryPath" -eq "") { return $false; }
	$CurrentDir = $(pwd).Path
	$ret = $false
	try {
		cd "$DirectoryPath"
		$ret = $(git rev-parse --is-inside-work-tree)
		Write-Host "Error did NOT occur in IsGitWorkingDirectory()."
	}
	catch {
		$ret = $false
		Write-Host "ERROR in IsGitWorkingDirectory(): $($_.Exception.Message)"
	}
	cd "$CurrentDir"
	return $ret
}


function GitCloneOrUpdate($RepositoryAddress = $null,
	$BranchTag)
# Returns a set of parts of the string version of form "1.2.3.4"
{
	if ($versionString -eq $null -or $versionString -eq "") 
	{ $versionString = "1.0.0.0" }
	return $versionString.Replace(".",",").Split(",")
}



