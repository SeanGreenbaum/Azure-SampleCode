#Delete all groups that look like $keyword

$keyword = "group"

#See authentication examples in /Authentication folder. The #header variable is built there
$output = Invoke-RestMethod -Method Get -Headers $headers -Uri "https://graph.microsoft.com/beta/groups"
$temp = $output.value | Where-Object {$_.displayname -like $keyword} 
$temp | ForEach-Object {
    $tid = $_.id
    $tname = $_.displayName
    Write-Host "Deleting group name: $tname     id: $tid"
    Invoke-RestMethod -Method Delete -Headers $headers -Uri "https://graph.microsoft.com/beta/groups/$tid"
}