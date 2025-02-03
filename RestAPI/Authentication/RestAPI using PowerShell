## Setup to run Rest API queries via PowerShell
$tenantname = "azlab.seantoso.com"

Connect-AzAccount -tenant $tenantname
$securetoken = (Get-AzAccessToken -AsSecureString).Token # Might need to perform Connect-AzAccount first
$Token = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securetoken))

$headers = @{
    "Authorization" = "Bearer $Token"
    "Content-Type" = "application/json"
}
