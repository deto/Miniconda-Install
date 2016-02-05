#!/usr/bin/env bash

# Name of application to install
AppName="YourApplicationName"

# Set your project's install directory name here
InstallDir="YourApplicationFolder"

# Dependencies installed by Conda
# Commend out the next line if no Conda dependencies
CondaDeps="numpy scipy scikit-learn pandas"

# Dependencies installed with pip instead
# Comment out the next line if no PyPi dependencies
PyPiDeps="YourApplicationName"

# Local packages to install
# Useful if your application is not in PyPi
# Distribute this with a .tar.gz and use this variable
# Comment out the next line if no local package to install
LocalPackage="mypackage.tar.gz"

# Entry points to add to the path
# Comment out the next line of no entry point
#   (Though not sure why this script would be useful otherwise)
EntryPoint="YourApplicationName"

echo
echo "Installing $AppName"

echo
echo "Installing into: $(pwd)/$InstallDir"
echo

# Miniconda doesn't work for directory structures with spaces
if [[ $(pwd) == *" "* ]]
then
    echo "ERROR: Cannot install into a directory with a space in its path" >&2
    echo "Exiting..."
    echo
    exit 1
fi

# Test if new directory is empty.  Exit if it's not
if [ "$(ls -A $(pwd)/$InstallDir)" ]; then
    echo "ERROR: Directory is not empty" >&2
    echo "If you want to install into $(pwd)/$InstallDir, "
    echo "clear the directory first and run this script again."
    echo "Exiting..."
    echo
    exit 1
fi

# Download and install Miniconda
curl "https://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh" -o Miniconda_Install.sh

bash Miniconda_Install.sh -b -f -p $InstallDir

# Activate the new environment
$InstallDir/bin/activate

# Install Conda Dependencies
if [[ -v CondaDeps ]]; then
    conda install $CondaDeps -y
fi

# Install PyPi Dependencies
if [[ -v PyPiDeps ]]; then
    pip install $PyPiDeps -q
fi

# Install Local Package
if [[ -v LocalPackage ]]; then
    pip install $LocalPackage -q
fi

# Add Entry Point to the path
if [[ -v EntryPoint ]]; then

    cd $InstallDir
    mkdir Scripts
    ln -s ../bin/$EntryPoint Scripts/$EntryPoint

    echo "$EntryPoint script installed to $(pwd)/Scripts"
    echo
    echo "Add folder to path by appending to .bashrc?"
    read -p "[y/n] >>> " -r
    echo
    if [[ ($REPLY == "yes") || ($REPLY == "Yes") || ($REPLY == "YES") ||
        ($REPLY == "y") || ($REPLY == "Y")]]
    then
        echo "export PATH=\"$(pwd)/Scripts\":\$PATH" >> ~/.bashrc
        echo "Your PATH was updated."
        echo "Restart the terminal for the change to take effect"
    else
        echo "Your PATH was not modified."
    fi

    cd ..
fi

# Cleanup
rm Miniconda_Install.sh

echo
echo "$AppName Install Successfully"
