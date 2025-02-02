#Access Graph using a Managed Identity

#Connect using AZ Powershell and a System Assigned Managed Identity
Connect-AzAccount -Identity

#Connect using AZ Powershell and a User Assigned Managed Identity
Connect-AzAccount -Identity -AccountId <UserAssignedManagedIdentityClientId>

#Get a token using the Managed Identity
$Token = Get-AzAccessToken -ResourceUrl "https://graph.microsoft.com"
$headers = @{
  "Authorization" = "Bearer $($Token.token)"
  "Content-type" = "application/json"
}

#Call the Graph API using the token
$endpoint = "v1.0"  #v1.0 or beta
$uri = "https://graph.microsoft.com/$endpoint/users/"
$output = Invoke-RestMethod -Method Get -Headers $headers -Uri $uri