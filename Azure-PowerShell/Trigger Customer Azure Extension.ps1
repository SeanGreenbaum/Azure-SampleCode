#Runs the targeted ps1 script on the targeted VM using the CustomScriptExtension

#The ForceRerun parameter is used to force the extension to rerun the script. This is useful when you want to run the same script multiple times on the same VM.
#You will need to authenticate to Azure prior to using this code. You can do this by running the Connect-AzAccount command.


$storageaccountname = "<storageaccountname>"
$directory = "<directory>"
$scriptname = "<scriptname>"
$sastoken = "<sastoken>"
$region = "<region>"
$resourceGroupName = "<resourceGroupName>"
$vmName = "<vmName>"

$commandSettings = @{
    ResourceGroupName = $resourceGroupName
    VMName = $vmName
    Name = 'CustomScriptExtension-MyScript'
    FileUri = "https://$storageaccountname.blob.core.windows.net/${directory}/${scriptname}?${sastoken}"
    Run = $scriptname
    Location = $region
    ForceRerun = (Get-Date).Ticks
}

Set-AzVMCustomScriptExtension @commandSettings