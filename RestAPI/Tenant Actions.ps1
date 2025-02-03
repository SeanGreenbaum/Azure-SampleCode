#Build common header
$headers = @{
    "Authorization" = "Bearer $Token"
    "Content-Type" = "application/json"
}


#Get list of tenants your account has access to
$apiversion = "2024-08-01"
$uri = "https://management.azure.com/tenants?api-version=$apiversion"
$Result = Invoke-RestMethod -Method Get -Uri $uri -Headers $headers
$Result.value | Format-Table displayName, defaultDomain, TenantId, TenantCategory