
# A sample script for initialization of repositories. You can adapt it for
# specific needs. Can also be used for testing.
# Function:
# * Defines some variables that will specify repositories location, addresses,
# checkout branches, etc.
# * Clones a repository without specifying a branches
# * Checks out specific branch 
# * Checks out specific tag
# https://github.com/ajgorhoe/IGLib.modules.IGLibScriptsPS.git

# Execute definitions from other files:
. $(Join-Path "$PSScriptRoot" "File.ps1")

# Import definitions:
Write-Host "`n`nImporting definitions..."
. $(Join-Path "$PSScriptRoot" "GitHelpers.ps1")



# Define location where repository is cloned, branch to be checked out, etc.:
$RepositoryDirectory=Join-Path "$PSScriptRoot" "testrepos"

$RepoIGLibScriptsSubdir="IGLibScriptsPS"
$RepoIGLibScriptsAddress="https://github.com/ajgorhoe/IGLib.modules.IGLibScriptsPS.git"
$RepoIGLibScriptsBranchCloned=$null
$RepoIGLibScriptsBranch="remotes/origin/release/21_08_release_1.9.1"
$RepoIGLibScriptsTag="save/21_11_26_IglibContainsExternal_DemoAppsWork"
$RepoIGLibScriptsBranchDefault="master"

# Parameters for specific scripts:
$RepoIGLibScriptsParam = @($RepoIGLibScriptsAddress, 
	$RepoIGLibScriptsSubdir, $RepoIGLibScriptsBranch)
# Parameters for all repos, enable iterations over them:
$RepoParams = @($RepoIGLibScriptsParam) 

Write-Host "`n`nCloning repository into $RepoIGLibScriptsSubdir ..."
$RepoDir=Join-Path "$RepositoryDirectory" "$RepoIGLibScriptsSubdir"
GitClone $RepoIGLibScriptsAddress $RepoDir
Write-Host "`nCloning finished. Verification (id Git repo): " $(IsGitRoot $RepoDir) "`\n"




