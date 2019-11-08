# Description: Boxstarter Script
# Author: Microsoft + Massimiliano Donini
# Common settings for web dev

Disable-UAC

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

#--- Setting up Windows ---
executeScript "FileExplorerSettings.ps1";
executeScript "SystemConfiguration.ps1";
executeScript "CommonDevTools.ps1";
executeScript "RemoveDefaultApps.ps1";
executeScript "WSL.ps1";
executeScript "Browsers.ps1";
executeScript "Tools.ps1";

Update-SessionEnvironment

choco install -y visualstudio2017professional --package-parameters="'--add Microsoft.VisualStudio.Component.Git'"
Update-SessionEnvironment #refreshing env due to Git install

choco install -y visualstudio2019-workload-azure
choco install -y visualstudio2019-workload-universal
choco install -y visualstudio2019-workload-manageddesktop
choco install -y visualstudio2019-workload-netcoretools
choco install -y visualstudio2019-workload-netweb

#--- Create code folder
mkdir C:\Code

#--- Install Azure DevOps CLI
az extension add --name azure-devops

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
