
This directory contains additional scripts that should reside in local 
directories that perform bootstrapping (usually named bootstrappingscripts/).

This is the reference source for these scripts. the botstrapping directory
contains scripts from this directory and some scripts from ../ (and possibly
other directories) of this repository.

The current repository will usually be directly contained in the
bootstrapping directory (usually .../bootstrappingscripts/ or something 
similar). The script 
  UpdateBootstrappingScripts.bat
Copies all the scripts that are needed in the bootstrapping directory to 
that directory (which is two levels lower than this directory) from the
current working copy of this directory. 

Since this repository is a reference source for all the scripts needed for
bootstrapping, this is the normmal workflow for 
UPDATING the BOOTSTRAPPING SCRIPTS:
1. Make sure that working copy of this repository is cloned inside the 
    bootstrapping directory. If not then execute the following command in the
	bootstrapping directory:
	  git clone 
2. Make sure that the appropriate branch / tag of this repository is checked
   out (normally, this should be the master branch).
2. Perform git pull within this repository, to update to the latest version.
3. Run the UpdateBootstrappingScripts.bat contained in the current directory.
4. Commit and push changes in the bootstrapping directory. It is always
   recommended that the 


