# Description: Boxstarter Script
# Author: Microsoft

Disable-UAC
$ConfirmPreference = "None" # Ensure installing powershell modules don't prompt on needed dependencies

# Load external scripts
# Get the base URI path from the ScriptToCall value
$bstrappackage = "-bootstrapPackage"
$helperUri = $Boxstarter['ScriptToCall']
$strpos = $helperUri.IndexOf($bstrappackage)
$helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
$helperUri = $helperUri.TrimStart("'", " ")
$helperUri = $helperUri.TrimEnd("'", " ")
$helperUri = $helperUri.Substring(0, $helperUri.LastIndexOf("/"))
$helperUri += "/scripts"
write-host "helper script base URI is $helperUri"

function executeScript {
    Param ([string]$script)
    write-host "executing $helperUri/$script ..."
	iex ((new-object net.webclient).DownloadString("$helperUri/$script"))
}

#--- Running external scripts first ---
executeScript "RemoveDefaultApps.ps1";
executeScript "SystemConfiguration.ps1";

#--- Setting up hardware ---
# choco install -y geforce-experience 

#--- Setting up apps ---
choco install -y firefox
choco install -y ublockorigin-firefox
choco install -y enpass.install
choco install -y authy-desktop
choco install -y telegram.install
choco install -y chocolatey
choco install -y microsoft-teams 

#--- Setting up work tools ---
choco install -y vscode
choco install -y greenshot
choco install -y git --package-parameters="'/GitAndUnixToolsOnPath /WindowsTerminal'"
choco install -y 7zip.install
choco install -y powershell-core
choco install -y cmdermini
choco install -y curl

#--- Setting up Azure tools ---
choco install -y azure-cli
choco install -y microsoftazurestorageexplorer

#--- Setting up Games and media ---
# choco install -y vlc
# choco install -y steam
# choco install -y discord

#--- Virtualisation et al ---
#executeScript "HyperV.ps1";
#RefreshEnv
#executeScript "WSL.ps1";
#RefreshEnv
#executeScript "Docker.ps1";

#--- Explorer settings ---
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtensions
Set-TaskbarOptions -Size Small -Lock -Combine Always -AlwaysShowIconsOn

#---Updates, UAC, Reboot.
Disable-GameBarTips
Disable-BingSearch
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
Enable-UAC
