Connect-AzAccount 
$Token = Get-AzAccessToken -ResourceUrl "https://graph.microsoft.com"

$headers = @{
  "Authorization" = "Bearer $($Token.token)"
  "Content-type" = "application/json"
}
