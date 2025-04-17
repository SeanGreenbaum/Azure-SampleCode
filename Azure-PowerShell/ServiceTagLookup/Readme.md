# FindIPinServiceTag.ps1

## Overview
`FindIPinServiceTag.ps1` is a PowerShell script designed to help you quickly identify Azure service tags associated with specific IP addresses. This script simplifies the process of determining which Azure service tags correspond to given IP addresses, making network management and security tasks easier.

## Prerequisites
- PowerShell installed on your system.
- An internet connection to download the current Azure Service Tag JSON file or have already downloaded a local copy of the latest JSON file

## Usage
Run the script from your PowerShell terminal:

```powershell
.\FindIPinServiceTag.ps1 -IPAddress <IP_Address>
```

### Example to check which service tag IP address 13.107.42.16 belongs to in the Azure Public Cloud
```powershell
.\FindIPinServiceTag.ps1 -IPAddress 13.107.42.16
```

### Example to check which service tag IP address 13.107.42.16 belongs to in the Azure Gov Cloud
```powershell
.\FindIPinServiceTag.ps1 -IPAddress 13.107.42.16 -Gov
```

### Example to check which service tag IP address 13.107.42.16 belongs to using a local JSON file previously downloaded from Microsoft
```powershell
.\FindIPinServiceTag.ps1 -IPAddress 13.107.42.16 -file C:\temp\AzurePublicServiceTags.json
```

## Parameters
| Parameter | Description | Required |
|-----------|-------------|----------|
| `-IPAddress <IPAddress>` | The IP address you want to find the Azure service tag for. | Yes |
| `-Gov` | Switch to indicate you want to check the IP address against the Azure US Gov service tag json file. | No |
| `-File <filename>` | To indicate you already have downloaded the latest Azure Service Tag (Public or Gov) JSON file and would like to check the IP address agaisnt that file. | No |

## Output
The script returns the Azure service tag(s) associated with the provided IP address.
- Many IP Addresses will exist under multiple service tags. Typically they exist under:
  - The name of the Service (ie. Storage)
  - The name of the Service in a Region (ie. Storage.EastUS2)
  - The name of the Region (ie. AzureCloud.EastUS2)
  - The all up Azure Cloud tag (ie. AzureCloud)

```powershell
.\FindIPinServiceTag.ps1 -IpAddress 13.68.120.66
---Found---                                                                                                             
Name: Storage
Region:
Subnet 13.68.120.64/28
---Found---
Name: Storage.EastUS2
Region: eastus2
Subnet 13.68.120.64/28
---Found---
Name: AzureCloud.eastus2
Region: eastus2
Subnet 13.68.0.0/17
---Found---
Name: AzureCloud
Region:
Subnet 13.68.0.0/17

Total number of matches: 4
```

## Notes
- Ensure you have either an internet connection to be able to access the latest JSON file online, or you have already downloaded the JSON file locally.

## Limitations
Currently the script does not parse or check IPv6 addresses. Azure does support IPv6 and Service Tags do contain IPv6 information, it just isn't yet in the scripts abilities.

## Contributing
Feel free to submit issues or pull requests to improve this script.

## License
This project is licensed under the MIT License.