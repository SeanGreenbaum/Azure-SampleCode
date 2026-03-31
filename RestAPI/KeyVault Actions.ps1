#Authenticate to Entra ID using a User Assigned Managed Identity via IMDS endpoint
#Then query a secret from Azure Key Vault using the obtained token

# ---- Configuration ----
$clientId      = "<UserAssignedManagedIdentityClientId>"  # Client ID of the User Assigned Managed Identity
$vaultName     = "<YourKeyVaultName>"                      # Name of the Key Vault
$secretName    = "<YourSecretName>"                        # Name of the secret to retrieve

# ---- Authenticate to Entra ID via IMDS for Key Vault access (Azure Government) ----
$resource = "https://vault.usgovcloudapi.net"
$imdsUrl  = "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=$resource&client_id=$clientId"

$tokenResponse = Invoke-RestMethod -Uri $imdsUrl -Method GET -Headers @{ Metadata = "true" }
$accessToken   = $tokenResponse.access_token

# ---- Retrieve secret from Key Vault ----
$secretUri = "https://$vaultName.vault.usgovcloudapi.net/secrets/${secretName}?api-version=7.4"
$headers   = @{
    "Authorization" = "Bearer $accessToken"
}

$secret = Invoke-RestMethod -Uri $secretUri -Method GET -Headers $headers
Write-Output "Secret Name : $($secret.id)"
Write-Output "Secret Value: $($secret.value)"
