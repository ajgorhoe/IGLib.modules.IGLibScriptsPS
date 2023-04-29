
# Helper utilities for dealing with reopsitories:
# https://github.com/ajgorhoe/IGLib.modules.IGLibScripts.git

#Auxiliary variables - enable verification in the calling script:
$ScriptHasRun_GitHelpers = $true
$ScriptDirectory_GitHelpers = $PSScriptRoot

. $(Join-Path "$PSScriptRoot" "File.ps1")

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
	if ("$ParentDir" -eq "") 
	{
		Write-Host "`GetGitRoot(): not a Git working directory.`n"
		return $null 
	}
	return GetGitRoot "$ParentDir"
}

function GetGitBranch($DirectoryPath = ".")
{
	if ("$DirectoryPath" -eq "") { $DirectoryPath = "." }
	if (-not (IsGitWorkingDirectory "$DirectoryPath"))
	{
		Write-Host "`nGetGitBranch(): not a Git working directory.`n"
		return $null
	}
	$InitialDir = $(pwd).Path
	$ret = $null
	try {
		if ("$DirectoryPath" -ne "") { cd "$DirectoryPath" }
		$ret = $(git rev-parse --abbrev-ref HEAD)
	}
	catch {
		Write-Host "ERROR in GetGitBranch(): $($_.Exception.Message)`n"
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
		Write-Host "`nGetGitCommit(): not a Git working directory.`n"
		return $null
	}
	$InitialDir = $(pwd).Path
	$ret = $null
	try {
		if ("$DirectoryPath" -ne "") { cd "$DirectoryPath" }
		$ret = $(git rev-parse HEAD)
	}
	catch {
		Write-Host "`nERROR in GetGitCommit(): $($_.Exception.Message)`n"
	}
	finally {
		cd "$InitialDir"
	}
	return $ret
}


function GitClone ($RepositoryAddress = $null, 
	$CloneDirectory = $null, $BranchCommitOrTag = $null )
{
	if ("$RepositoryAddress" -eq "")
	{
		Write-Host "Error: GitClone(): RepositoryAddress not specified"
		return;
	}
	if ("$CloneDirectory" -ne "")
	{
		if (IsGitWorkingDirectory "$CloneDirectory")
		{
			Write-Host "`nGitClone(): Directory already contains a Git repository: $CloneDirectory`n"
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

function GitUpdate ($CloneDirectory = ".", $BranchCommitOrTag = $null )
{
	$InitialDir = $(pwd).Path
	$ret = $null
	if ("$CloneDirectory" -eq "") { $CloneDirectory = "." }
	if (-not (IsGitWorkingDirectory "$CloneDirectory"))
	{
		Write-Host "`nError: GitUpdate(): Not a Git working directory: $CloneDirectory`n"
		return
	}
	try 
	{
		cd "$CloneDirectory"
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



