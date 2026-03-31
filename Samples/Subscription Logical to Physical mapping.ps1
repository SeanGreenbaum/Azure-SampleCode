# Setup to run Rest API queries via PowerShell
$tenantname = "contoso.com"
$subscriptionid = "Insert Subscription ID here"
$apiversion = "2024-07-01"

Connect-AzAccount -Tenant $tenantname
$Result = (Invoke-AzRestMethod -Path "/subscriptions/$($subscriptionid)/locations?api-version=$apiversion" -Method GET).Content 
$Result | ConvertFrom-Json | Select-Object -ExpandProperty value | 
    Where-Object { $_.availabilityZoneMappings } |
    Select-Object name, displayName, @{
        Name = 'availabilityZoneMappings'
        Expression = { ($_.availabilityZoneMappings | ForEach-Object { "Logical Zone $($_.logicalZone)=Physical Zone $($_.physicalZone)" }) -join ', ' }
    } | Format-Table -AutoSize -Wrap