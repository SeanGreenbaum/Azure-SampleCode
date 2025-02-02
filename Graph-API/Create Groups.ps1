#Create 300 groups named Group1001-Group1300
#Group.Create permission needed

#See authentication examples in /Authentication folder. The #header variable is built there
$endpoint = "beta"
$uri = "https://graph.microsoft.com/$endpoint/groups/"

for ($x = 1001; $x -lt 1300; $x++)
{
    $groupname = "Group" + $x
    $PostMessage = @{
      "description"= $groupname
      "displayName"= $groupname
      "mailEnabled"= "false"
      "mailNickName"= $groupname
      "securityEnabled"= "true"
    } | ConvertTo-Json
    $output = Invoke-RestMethod -Method Post -Headers $headers -Body $PostMessage -Uri $uri
    $groupId = $output.id
    Write-Host "GroupName: $groupname       GroupID: $groupId"
}
