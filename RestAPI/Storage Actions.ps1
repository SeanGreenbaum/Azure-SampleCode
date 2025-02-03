$headers = @{
    "Authorization" = "Bearer $Token"
    "Content-Type" = "application/json"
}
#Lots of reads against the Storage RP
$SubscriptionID = ""
$RGName = ""
$storageaccountname = ""
$apiversion = "2022-09-01" #API Version for Microsoft.Compute. Update as per your Resource Provider
for ($x=1; $x -le 801; $x++)
{
    $readResponse = Invoke-WebRequest -Uri "https://management.azure.com/subscriptions/$subscriptionID/resourceGroups/$RGName/providers/Microsoft.Storage/storageAccounts/$storageaccountname/blobServices/default?api-version=$apiversion" -Method GET -Headers $headers
    $x
}
$readResponse.Headers

#Create a SAS token for Blob storage
$SubscriptionID = ""
$RGName = ""
$storageaccountname = ""
$apiversion = "2022-09-01" #API Version for Microsoft.Compute. Update as per your Resource Provider
$containername = "mycontainer"
$SASValidtimeDays = 7 #Number of days the SAS token is valid

$ExpiryTime = (Get-Date).AddDays($SASValidtimeDays).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssK") #Adds X days to today and sets in ISO 8601 standard
$params = @{
    "canonicalizedResource" = "/blob/$storageaccountname/$containername"
    "signedResource" = "c"
    "signedPermission" = "r"
    "signedProtocol" = "https"
    "signedExpiry" = $ExpiryTime
} | ConvertTo-Json

    #Using Invoke-WebRequest to get the SAS token
    $sasResponse = Invoke-WebRequest -Uri "https://management.azure.com/subscriptions/$subscriptionID/resourceGroups/$RGName/providers/Microsoft.Storage/storageAccounts/$storageaccountname/listServiceSas/?api-version=$apiversion" -Method POST -Body $params -Headers $headers
    $sasContent = $sasResponse.Content | ConvertFrom-Json
    $sasCred = $sasContent.serviceSasToken
    $sasCred

    #Using Invoke-RestMethod to get the SAS Token
    $sasResponse = Invoke-RestMethod -Uri "https://management.azure.com/subscriptions/$subscriptionID/resourceGroups/$RGName/providers/Microsoft.Storage/storageAccounts/$storageaccountname/listServiceSas/?api-version=$apiversion" -Method POST -Body $params -Headers $headers
    $sasCred = $sasResponse.serviceSasToken
    $sasCred

#Downloads a file from blob storage using SAS token
$storageaccountname = ""
$containername = ""
$filename = ""
$sasCred = "" #SAS token generated in the previous step
$downloadpath = "C:\temp\"
$filename = "myblob.txt"

$Outfile = $downloadpath + $filename
Invoke-WebRequest -Uri "https://$($storageaccountname).blob.core.windows.net/$($containername)/$($filename)?$sasCred" -OutFile $Outfile

#Creates a SAS token for File storage
$SubscriptionID = ""
$RGName = ""
$storageaccountname = ""
$apiversion = "2022-09-01" #API Version for Microsoft.Compute. Update as per your Resource Provider
$filesharename = "myshare"
$SASValidtimeDays = 7 #Number of days the SAS token is valid
$ExpiryTime = (Get-Date).AddDays($SASValidtimeDays).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssK") #Adds X days to today and sets in ISO 8601 standard
$params = @{
    "canonicalizedResource" = "/file/$storageaccountname/$filesharename"
    "signedResource" = "s"
    "signedPermission" = "r"
    "signedProtocol" = "https"
    "signedExpiry" = $ExpiryTime
} | ConvertTo-Json

    #Using Invoke-WebRequest to get the SAS token
    $sasResponse = Invoke-WebRequest -Uri "https://management.azure.com/subscriptions/$subscriptionID/resourceGroups/$RGName/providers/Microsoft.Storage/storageAccounts/$storageaccountname/listServiceSas/?api-version=2022-09-01" -Method POST -Body $params -Headers @{Authorization="Bearer $ArmToken"}
    $sasContent = $sasResponse.Content | ConvertFrom-Json
    $sasCred = $sasContent.serviceSasToken
    $sasCred

    #Using Invoke-RestMethod to get the SAS Token
    $sasResponse = Invoke-RestMethod -Uri "https://management.azure.com/subscriptions/$subscriptionID/resourceGroups/$RGName/providers/Microsoft.Storage/storageAccounts/$storageaccountname/listServiceSas/?api-version=2022-09-01" -Method POST -Body $params -Headers @{Authorization="Bearer $ArmToken"}
    $sasCred = $sasResponse.serviceSasToken
    $sasCred

#Downloads a file from file storage using SAS token
$storageaccountname = ""
$containername = ""
$filename = ""
$sasCred = "" #SAS token generated in the previous step
$downloadpath = "C:\temp\"
$filename = "myblob.txt"

$Outfile = $downloadpath + $filename
Invoke-WebRequest -Uri "https://$($storageaccountname).file.core.windows.net/$($containername)/$($filename)?$sasCred" -OutFile $Outfile

#If you want to use Entra ID to access the storage and not SAS, you need a different header
#Build common header
$headers = @{
    "x-ms-version" = "2024-11-04"
    "x-ms-date" = (Get-Date).AddHours(12).ToString("R")
    "Authorization" = "Bearer $Token"
    "x-ms-file-request-intent" = "backup"
}

#Check if a directory exists in file share and create if not exist
$storageaccountname = ""
$filesharename = ""
$dirname = "testdir"
$uri = "https://$storageAccountName.file.core.windows.net/$fileShareName/${dirname}?restype=directory"
try {
    Invoke-RestMethod -Method Get -Uri $uri -Headers $headers #Get tests for existance     
}
catch { #Folder doesn't exist, create it
    Invoke-RestMethod -Method Put -Uri $uri -Headers $headers #Put creates it
}

#List all Managed Disks in a Subscription
$subscriptionid = (Get-AzContext).Subscription.Id
$apiversion = "2024-03-02"
$Result = Invoke-RestMethod -Method Get -Uri "https://management.azure.com/subscriptions/$subscriptionid/providers/Microsoft.Compute/disks?api-version=$apiversion" -Headers $headers
$Result.value | Format-Table Name, location
