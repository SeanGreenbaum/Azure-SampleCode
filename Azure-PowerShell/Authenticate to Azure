#Various Powershell methods to authenticate to Azure using the AZ PowerShell modules

#Interactive prompt for login
Connect-AzAccount

#Service Principal login
$tenantId = "yourTenantId"
$appId = "yourAppId"
$appSecret = "yourAppSecret"
$securePassword = ConvertTo-SecureString $appSecret -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($appId, $securePassword)
Connect-AzAccount -ServicePrincipal -Credential $credential -Tenant $tenantId

#Managed Identity login
Connect-AzAccount -Identity

#Managed Identity login using a User Assigned Managed Identity
$identityId = "yourIdentityId"  #Client ID of the User Assigned Managed Identity
Connect-AzAccount -Identity -IdentityId $identityId

#Device Code login
Connect-AzAccount -UseDeviceAuthentication #This will prompt you to go to a URL and enter a code

#Certificate login
$tenantId = "yourTenantId"
$appId = "yourAppId"
$cert = Get-Item -Path "C:\path\to\your\certificate.pfx"
$securePassword = ConvertTo-SecureString -String "yourCertPassword" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($appId, $securePassword)
Connect-AzAccount -ServicePrincipal -Credential $credential -Tenant $tenantId -CertificateThumbprint $cert.Thumbprint



