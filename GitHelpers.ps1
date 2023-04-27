
# Helper utilities for dealing with reopsitories:
# https://github.com/ajgorhoe/IGLib.modules.IGLibScripts.git

#Auxiliary variables - enable verification in the calling script:
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

function IsGitRoot($DirectoryPath = ".")
{
	if ("$DirectoryPath" -eq "") { $DirectoryPath = "." }
	$GitRefDirectoryName = ".git/refs"
	$GitRefDirectoryPath = $(Join-Path "$DirectoryPath" `
		"$GitRefDirectoryName")
	return Test-Path "$GitRefDirectoryPath" -PathType Container
}


function IsGitWorkingDirectory($DirectoryPath = ".")
{
	if ("$DirectoryPath" -eq "") { $DirectoryPath = "." }
	if (IsGitRoot($DirectoryPath)) { return $true; }
	$ParentDir = GetParentDirectory "$DirectoryPath"
	if ("$ParentDir" -eq "") { return $false }
	return IsGitWorkingDirectory "$ParentDir"
}

function GetGitRoot($DirectoryPath = ".")
{
	if ("$DirectoryPath" -eq "") { $DirectoryPath = "." }
	if (IsGitRoot($DirectoryPath)) { 
		return (Resolve-Path $DirectoryPath).Path; }
	$ParentDir = GetParentDirectory "$DirectoryPath"
	if ("$ParentDir" -eq "") { return $null }
	return GetGitRoot "$ParentDir"
}

function GetGitBranch($DirectoryPath = ".")
{
	if ("$DirectoryPath" -eq "") { $DirectoryPath = "." }
	if (-not (IsGitWorkingDirectory "$DirectoryPath"))
	{
		return $null
	}
	$InitialDir = $(pwd).Path
	$ret = $null
	try {
		if ("$DirectoryPath" -ne "") { cd "$DirectoryPath" }
		$ret = $(git rev-parse --abbrev-ref HEAD)
	}
	catch {
		Write-Host "ERROR in GetGitBranch(): $($_.Exception.Message)"
	}
	finally {
		cd "$InitialDir"
	}
	return $ret
}

function GetGitCommit($DirectoryPath = ".")
{
	if ("$DirectoryPath" -eq "") { $DirectoryPath = "." }
	if (-not (IsGitWorkingDirectory "$DirectoryPath"))
	{
		return $null
	}
	$InitialDir = $(pwd).Path
	$ret = $null
	try {
		if ("$DirectoryPath" -ne "") { cd "$DirectoryPath" }
		$ret = $(git rev-parse "HEAD")
	}
	catch {
		Write-Host "ERROR in GetGitCommit(): $($_.Exception.Message)"
	}
	finally {
		cd "$InitialDir"
	}
	return $ret
}

<#
function GetGitBranch($DirectoryPath = ".")
{
	if ("$DirectoryPath" -eq "") { $DirectoryPath = "." }
	$InitialDir = $(pwd).Path
	try {
		if ("$DirectoryPath" -ne "") { cd "$DirectoryPath" }
		return $(git rev-parse --abbrev-ref HEAD)
	}
	catch {
		Write-Host "ERROR in IsGitWorkingDirectory(): $($_.Exception.Message)"
	}
	finally {
		cd "$InitialDir"
	}
	return $null
} #>

function GitClone ($RepositoryAddress = $null, 
	$CloneDirectory = $null, $BranchCommitOrTag = $null )
{
	if ("$RepositoryAddress" -eq "")
	{
		Write-Host "Error: GitClone: RepositoryAddress not specified"
		return;
	}
	if ("$CloneDirectory" -ne "")
	{
		if (IsGitRoot "$CloneDirectory")
		{
			Write-Host "Directory already contains Git repository: $CloneDirectory"
			return null;
		}
	}
	if ("$BranchCommitOrTag" -ne "")
	{
		. git clone "$RepositoryAddress" "$CloneDirectory" --branch "$BranchCommitOrTag"
	} else {
		. git clone "$RepositoryAddress" "$CloneDirectory"
	}
}

function GitUpdate ($CloneDirectory = $null, $BranchCommitOrTag = $null )
{
	$InitialDir = $(pwd).Path
	$ret = $null
	if ("$CloneDirectory" -eq "") { $CloneDirectory = "." }
	cd "$CloneDirectory"
	if (IsGitWorkingDirectory "." -eq $false)
	{
		return
	}
	try 
	{
		if ("$BranchCommitOrTag" -eq "")
		{
			# branch not specified
			. git pull
			return 
		}
		try
		{
			. git fetch --all --tags
			. git checkout "$BranchCommitOrTag"
			. git pull
		}
		catch {   }
		return 
	}
	finally { cd "$InitialDir"  }
}

function GitCloneOrUpdate($RepositoryAddress = $null, 
	$CloneDirectory = $null, $BranchCommitOrTag = $null )
{
	if ("$CloneDirectory" -eq "") { $CloneDirectory = "." }
	if ("$RepositoryAddres" -ne "")
	{
		GitClone "$RepositoryAddres" "$CloneDirectory" "$BranchCommitOrTag"
	}
}

function GitCloneOrUpdate($RepositoryAddress = $null,
	$BranchTagOrCommit=$null)
# Returns a set of parts of the string version of form "1.2.3.4"
{
	if ($versionString -eq $null -or $versionString -eq "") 
	{ $versionString = "1.0.0.0" }
	return $versionString.Replace(".",",").Split(",")
}



