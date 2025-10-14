$ARMurl = "https://management.usgovcloudapi.net/"  #If GOV Cloud
$ARMurl = "https://management.azure.com/" #If Public Cloud

#Build a common header
$headers = @{
    "Authorization" = "Bearer $Token"
    "Content-Type" = "application/json"
}


#List the Private IP addresses for an APIM instance
$subscriptionID = ""
$resourceGroupName = ""
$serviceName = ""
$url = "https://$ARMurl/subscriptions/$subscriptionID/resourceGroups/$resourceGroupName/providers/Microsoft.ApiManagement/service/$($serviceName)?api-version=2024-05-01"
$Response = Invoke-WebRequest -Uri $url -Method GET -Headers $headers

$apiminstance = $Response.Content | ConvertFrom-Json
Write-Host $apiminstance.location   $apiminstance.properties.privateIPAddresses   #Main Private IP
$apiminstance.properties.additionalLocations | ForEach-Object {Write-Host $_.location   $_.privateIPAddresses}