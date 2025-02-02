#Authenticate to Graph API using a certificate

#If you dont already have a certificate, you can create a self-signed certificate using the following command
New-SelfSignedCertificate -Subject "TestAzureCertAuth" -CertStoreLocation "Cert:\CurrentUser\My" -NotAfter (Get-Date).AddMonths(2) #Sample generating a cert for 2 months
#Certificate .CER file needs to be uploaded to Entra ID

#Get your certificate from the cert store by Thumbprint
$CertificateThumbprint = "<Cert Thumbprint>"
$cert = Get-ChildItem Cert:\CurrentUser\My\$CertificateThumbprint


#Connect to Graph API using MS Graph powershell modules
$graphPSconnectblob = @{
    TenantId = "<tenant id>"
    AppId = "<app id>"
    Certificate = $cert
}
Connect-MgGraph @graphPSconnectblob

#Connect to Graph API using Azure Powershell modules for authentication
$AZconnectblob = @{
    ApplicationId = "<app id>"
    TenantId = "<tenant id>"
    CertificateThumbprint = $CertificateThumbprint
}
Connect-AzAccount @AZconnectblob
$Token = Get-AzAccessToken -ResourceUrl "https://graph.microsoft.com"

$headers = @{
  "Authorization" = "Bearer $($Token.token)"
  "Content-type" = "application/json"
}

#Example using the token to get the users
$users = Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/users" -Headers $headers -Method Get