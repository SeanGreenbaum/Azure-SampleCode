#Different ways to authenticate to Azure using RestAPI and Managed Identity.
#Keep in mind the $resource URL may need to be different if you need an access token for a different resource.

# Authenticate to Azure using RestAPI and System Assigned Managed Identity and using Invoke-WebRequest
$resource="https://management.azure.com/"
$response = Invoke-WebRequest -Uri "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=$resource" -Method GET -Headers @{Metadata="true"} -UseBasicParsing
$content = $response.Content | ConvertFrom-Json
$Token = $content.access_token

#Authenticate to Azure using RestAPI and a User Assigned Managed Identity
$resource="https://management.azure.com/"
$clientId = "" #Client ID of the User Assigned Managed Identity and using Invoke-WebRequest
$response = Invoke-WebRequest -Uri "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=$resource&client_id=$clientId" -Method GET -Headers @{Metadata="true"}
$content = $response.Content | ConvertFrom-Json
$Token = $content.access_token


#Authenticate to Azure using RestAPI and a System Assigned Managed Identity using Invoke-RestMethod
$resource="https://management.azure.com/"
$response = Invoke-RestMethod -Uri "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=$resource" -Method GET -Headers @{Metadata="true"} -UseBasicParsing
$Token = $response.access_token

#Authenticate to Azure using RestAPI and a User Assigned Managed Identity using Invoke-RestMethod
$resource="https://management.azure.com/"
$clientId = "" #Client ID of the User Assigned Managed Identity and using Invoke-WebRequest
$response = Invoke-RestMethod -Uri "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=$resource&client_id=$clientId" -Method GET -Headers @{Metadata="true"}
$Token = $response.access_token

#Connect using AZ Powershell and a System Assigned Managed Identity
Connect-AzAccount -Identity

#Connect using AZ Powershell and a User Assigned Managed Identity
Connect-AzAccount -Identity -AccountId "<UserAssignedManagedIdentityClientId>"
