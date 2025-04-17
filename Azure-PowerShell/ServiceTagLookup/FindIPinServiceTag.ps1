# Checks to see if the provided IP address is in the Azure Service Tags JSON file.
# If the -file switch is not used then the JSON file is downloaded from the Microsoft website.
# If the -gov switch is used then the government version of the JSON file is downloaded.
# The -file option requires a local file path to the JSON file.
# IPv6 Support is not implemented yet.

#Written by: Sean.Greenbaum@Microsoft.com
#Date: 04-17-2025
#Version: 1.0.1

# To execute this script to check if an IP address is in the Azure Public Service Tags JSON (live download from Internet):
# .\FindIPinServiceTag.ps1 -IpAddress <IP Address>

#To execute this script to check if an IP address is in the Azure Government Service Tags JSON (live download from Internet):
# .\FindIPinServiceTag.ps1 -IpAddress <IP Address> -gov

#To execute this script to check if an IP address is in the Azure Service Tags JSON (local file):
# .\FindIPinServiceTag.ps1 -IpAddress <IP Address> -file <Path to JSON file>

# Azure JSON files can be downloaded from:
# https://www.microsoft.com/en-us/download/details.aspx?id=56519 (Public)
# https://www.microsoft.com/en-us/download/details.aspx?id=57063 (Government)




[CmdletBinding(DefaultParameterSetName="Default")]
param (
    [Parameter(Mandatory=$true)][string]$IpAddress,
    [Parameter(Mandatory=$false,ParameterSetName="local")][string]$file,
    [Parameter(Mandatory=$false,ParameterSetName="gov")][switch]$gov
)

function Test-IPAddressType  #Tests if IP address is IPv4 or IPv6. Will be used later for IPv6 support.
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

function Test-Ip4InSubnet { #Checks an IP address against a subnet mask. Returns true if the IP address is in the subnet.
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

$publicURL = "https://www.microsoft.com/en-us/download/details.aspx?id=56519"  #Azure Public cloud Service Tags download location
$govURL = "https://www.microsoft.com/en-us/download/details.aspx?id=57063"   #Azure Government cloud Service Tags download location

if ($gov) #If using the -gov switch then use the government URL
{
    $url = $govURL
}
else { #If not using the -gov switch then use the public URL
    $url = $publicURL
}

if (-not $file)  #If not using the -file switch then download the JSON file from the Microsoft website
{
    $page = Invoke-WebRequest -Uri $url

    $AzureServiceTags = ($page.Links | Where {$_.href -like "*ServiceTags_*.json"}).href #Check the page links for the JSON file URL
    if (-not $AzureServiceTags) {
        Write-Error "Error: Unable to find the JSON URL in the page content."
        exit 1
    }
    $jsonContent = Invoke-RestMethod -Uri $AzureServiceTags #Download the JSON file from the URL
}
else #The -file switch was used so use the local file path provided by the user
{
    $content = Get-Content -Path $file -Raw
    $jsonContent = $content | ConvertFrom-Json
}

$count = 0

ForEach ($tag in $jsonContent.values) #Search the JSON data for the IP address
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
