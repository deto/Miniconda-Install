# Miniconda-Install
Cross-Platform solution to installing a stand-alone Python application using Miniconda

The main advantages to this approach is:
- Single command to install
- Install is fully isolated (won't interfere with, or be mixed up by an existing Python install)
- No dependencies needed prior to install

Here are three scripts (one for each major platform) which can be modified to perform an isolated install of a python application.  All that is needed is to configure a few environment variables at the top of the file and then the files can be run by:

## OSX or Linux
Download the file into the folder where you want to install the application.  Then, open a terminal and run either

    bash Linux_Install.sh

or

    bash OSX_Install.sh

depending on which OS you're using.

## Windows
Download the file into the folder where you want to install the application.  Then open the folder, right-click the file, and select "Run with PowerShell" from the popup menu.

## What does it do exactly?
The scripts run the following procedure:

1. Download Miniconda installer
2. Run Miniconda installer to generate an isolated Python install
3. Install dependencies with Conda (if specified)
4. Install other dependencies with pip (if specified)
5. Install a local package archive (if specified)
6. Add the applications entry point to the path by:
  1. Creating a new folder, Scripts,  in the Miniconda directory
  2. Sym-linking the entry script into the new folder
  3. Adding the new folder to the user's path

Symlinking the script is necessary, otherwise adding the /bin folder in the new python install to the path would also add it's python, conda, and pip applications (making this new install the main python - NOT what we want).

## Why do this?  Other solutions exist...
There are a number of other solutions for this kind of thing, however none of them worked for my application.  I developed these scripts for a project of mine and thought others might find them useful too.

### VirtualEnv
VirtualEnv is perfectly fine for developers but if your user isn't very command-line savvy, or is new to Python (maybe they use R, for example) then it's less than ideal.  I found it difficult to get the instructions down to a very small number of steps that accounted for the variable state of the system Python install, whether or not pip is installed, whether or not the user had admin privileges, etc.

###cx_freeze or PyInstaller
These are great tools, but I was unable to get them to work for my project.  I kept running into errors on certain packages and eventually gave up.  I'd definitely at least give one of these a go, though, before going the route presented here as your resulting install size will be much lower.
