#Access Graph API using a Service Principal

$clientId = "<SP client ID>"
$clientsecret = "<SP client secret>"
$tenantName = "<tenant id or name>"
$endpoint = "v1.0"  #v1.0 or beta
$ReqTokenBody = @{
    Grant_Type    = "client_credentials"
    Scope         = "https://graph.microsoft.com/.default"
    client_Id     = $clientID
    Client_Secret = $clientSecret
} 
$TokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$TenantName/oauth2/v2.0/token" -Method POST -Body $ReqTokenBody
$headers = @{
  "Authorization" = "Bearer $($TokenResponse.access_token)"
  "Content-type" = "application/json"
}

$uri = "https://graph.microsoft.com/$endpoint/users/"
$output = Invoke-RestMethod -Method Get -Headers $headers -Uri $uri