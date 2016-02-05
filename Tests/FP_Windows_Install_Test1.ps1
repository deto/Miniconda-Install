$ErrorActionPreference = "Stop"

# Name of application to install
$AppName="WindowsTest1"

# Set your project's install directory name here
$InstallDir="WindowsTest1"

# Dependencies installed by Conda
# Commend out the next line if no Conda dependencies
$CondaDeps="click","pygments"

# Dependencies installed with pip instead
# Comment out the next line if no PyPi dependencies
$PyPiPackage="autopep8"

# Local packages to install
# Useful if your application is not in PyPi
# Distribute this with a .tar.gz and use this variable
# Comment out the next line if no local package to install
# $LocalPackage="mypackage.tar.gz"

# Entry points to add to the path
# Comment out the next line of no entry point
#   (Though not sure why this script would be useful otherwise)
$EntryPoint="autopep8"

Write-Host ("`nInstalling $AppName to "+(get-location).path+"\$InstallDir")


# Download Latest Miniconda Installer
Write-Host "`nDownloading Miniconda Installer...`n"

(New-Object System.Net.WebClient).DownloadFile("https://repo.continuum.io/miniconda/Miniconda-latest-Windows-x86_64.exe", "$pwd\Miniconda_Install.exe")

# Install Python environment through Miniconda
Write-Host "Installing Miniconda...`n"
Start-Process Miniconda_Install.exe "/S /AddToPath=0 /D=$pwd\$InstallDir" -Wait

# Install Dependences to the new Python environment
$env:Path = "$pwd\$InstallDir\Scripts;" + $env:Path

if(Test-Path variable:CondaDeps)
{
    Write-Host "Installing Conda dependencies...`n"
    conda install $CondaDeps -y
}

if(Test-Path variable:PyPiPackage)
{
    Write-Host "Installing PyPi dependencies...`n"
    pip install $PyPiPackage
}

if(Test-Path variable:LocalPackage)
{
    Write-Host "Installing Local package...`n"
    pip install $LocalPackage
}

# Add Entry Point to path

if(Test-Path variable:EntryPoint)
{
    # Move entry-point executable to an isolated folder
    $script_folder = "$pwd\$InstallDir\PathScripts"
    New-Item $script_folder -type directory | Out-Null
    Move-Item $pwd\$InstallDir\Scripts\$EntryPoint.exe $script_folder

    # Ask user if they want to update path
    $title = "Update Path"
    $message = "`nDo you want to add the $EntryPoint script to your User PATH?"

    $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
        "Prepends the User PATH variable with the location of the $EntryPoint script"

    $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
        "User PATH is not modified"

    $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

    $result = $host.ui.PromptForChoice($title, $message, $options, 0) 

    if($result -eq 0)
    {
        # Update the user's path
        $old_path = (Get-ItemProperty -Path HKCU:\Environment).Path
        $new_path = $script_folder + ";" + $old_path
        cmd /c "setx PATH $new_path"
        Set-ItemProperty -Path HKCU:\Environment -Name PATH -Value $new_path
        Write-Host "User PATH has been updated"
        Write-Host "Restart your terminal to see change"
    }
    else
    {
        Write-Host "User PATH was not modified.`n"
        Write-Host "You may want to add the $EntryPoint script to your path."
        Write-Host "It is located in: $script_folder`n"
    }
}

# Cleanup
Remove-Item "Miniconda_Install.exe"

Write-Host "`n$AppName Successfully Installed"
