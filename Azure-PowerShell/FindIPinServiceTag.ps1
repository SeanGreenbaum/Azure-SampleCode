# Checks to see if the provided IP address is in the Azure Service Tags JSON file.
# If the -file switch is not used then the JSON file is downloaded from the Microsoft website.
# If the -gov switch is used then the government version of the JSON file is downloaded.
# The -file option requires a local file path to the JSON file.
# IPv6 Support is not implemented yet.

#Written by: Sean.Greenbaum@Microsoft.com
#Date: 04-14-2025
#Version: 1.0.0

[CmdletBinding(DefaultParameterSetName="Default")]
param (
    [Parameter(Mandatory=$true)][string]$IpAddress,
    [Parameter(Mandatory=$false,ParameterSetName="local")][string]$file,
    [Parameter(Mandatory=$false,ParameterSetName="gov")][switch]$gov
)

function Test-IPAddressType
{
    param (
        [Parameter(Mandatory=$true)][string]$IpAddress
    )

    try {
        [ipaddress]$ip = $IpAddress
        if ($ip.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork) {
            return "IPv4"
        } elseif ($ip.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetworkV6) {
            return "IPv6"
        } 
    }
    catch 
    {
        return "Unknown"
    }
}

function Test-Ip4InSubnet {
    param (
        [Parameter(Mandatory=$true)][string]$IpAddress,
        [Parameter(Mandatory=$true)][string]$Subnet
    )

    # Convert IP and subnet to IPAddress objects
    $ip = [System.Net.IPAddress]::Parse($IpAddress)
    $subnetParts = $Subnet.Split('/')
    $network = [System.Net.IPAddress]::Parse($subnetParts[0])
    $prefixLength = [int]$subnetParts[1]

    # Convert IP addresses to byte arrays
    $ipBytes = $ip.GetAddressBytes()
    $networkBytes = $network.GetAddressBytes()

    # Calculate subnet mask
    $maskBytes = [byte[]]@(0,0,0,0)
    for ($i = 0; $i -lt 4; $i++) {
        if ($prefixLength -ge 8) {
            $maskBytes[$i] = 255
            $prefixLength -= 8
        } elseif ($prefixLength -gt 0) {
            $maskBytes[$i] = [byte](256 - [math]::Pow(2, 8 - $prefixLength))
            $prefixLength = 0
        }
    }

    # Check if IP is in subnet
    for ($i = 0; $i -lt 4; $i++) {
        if (($ipBytes[$i] -band $maskBytes[$i]) -ne ($networkBytes[$i] -band $maskBytes[$i])) {
            return $false
        }
    }
    return $true
}

$publicURL = "https://www.microsoft.com/en-us/download/details.aspx?id=56519"
$govURL = "https://www.microsoft.com/en-us/download/details.aspx?id=57063"

if ($gov)
{
    $url = $govURL
}
else {
    $url = $publicURL
}

if (-not $file)
{
    $page = Invoke-WebRequest -Uri $url

    $AzureServiceTags = ($page.Links | Where {$_.href -like "*ServiceTags_*.json"}).href
    if (-not $AzureServiceTags) {
        Write-Error "Error: Unable to find the JSON URL in the page content."
        exit 1
    }
    $jsonContent = Invoke-RestMethod -Uri $AzureServiceTags
}
else 
{
    $content = Get-Content -Path $file -Raw
    $jsonContent = $content | ConvertFrom-Json
}

$count = 0

ForEach ($tag in $jsonContent.values) 
{
    if ((Test-IPAddressType -IpAddress $IpAddress) -eq "IPv4")
    {
        ForEach ($ipPrefix in $tag.properties.addressPrefixes) {
            if (Test-Ip4InSubnet -IpAddress $IpAddress -Subnet $ipPrefix) {
                Write-Host "---Found---"
                Write-Host "Name: $($tag.name)"
                Write-Host "Region: $($tag.properties.region)"
                Write-Host "Subnet $ipPrefix"
                $count++
            } 
        }
    }
    else
    {
        Write-Error "Error: Invalid IP address format."
        exit 1
    }
}
Write-Host "`nTotal number of matches: $count"
