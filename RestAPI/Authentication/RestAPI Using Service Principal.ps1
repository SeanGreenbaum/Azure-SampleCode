#PowerShell script to authenticate to Azure using Service Principal
$AppID = "YourAppID"
$ClientSecret = "YourClientSecret"
$tenantId = "YourTenantID"

$SecureStringPwd = $ClientSecret | ConvertTo-SecureString -AsPlainText -Force
$pscredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $AppId, $SecureStringPwd
Connect-AzAccount -ServicePrincipal -Credential $pscredential -Tenant $tenantId


#Authenticate to Azure using RestAPI and a Service Principal

$AppID    = ''
$Secret   = ''
$TenantID = ''
$Resource = "https://management.azure.com/"
$TokenUri = "https://login.microsoftonline.com/$TenantID/oauth2/token/"
$Body     = "client_id=$AppId&client_secret=$Secret&resource=$Resource&grant_type=client_credentials"

$TokenResult = Invoke-RestMethod -Uri $TokenUri -Body $Body -Method "POST"
$Token = $TokenResult.access_token
$headers = @{
    "Authorization" = "Bearer $Token"
}

