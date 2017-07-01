# Pre-Reqs all met
# Installed PowerTool MSI


# Find UCS PowerTools modules
Get-Module -ListAvailable

# List Module cmdlets
Get-Command -Module Cisco.UcsManager | measure

# get-help
Get-Help Connect-Ucs

# Connect to UCSM
$handle1 = Connect-Ucs -Name 10.0.30.77

# Get details of that session
Get-UcsPSSession

# Connect to multiple UCS devices
Set-UcsPowerToolConfiguration -SupportMultipleDefaultUcs $true


# Exporting a session and creating a secure key
# Export-UcsPSSession -LiteralPath C:\temp\cisco\ucspe2.xml
# ConvertTo-SecureString -String "Password" -AsPlainText -Force | ConvertFrom-SecureString | Out-File C:\temp\cisco\ucspe2.key

# Connect to Second UCSM using secure key
$key = ConvertTo-SecureString (Get-Content C:\temp\cisco\ucspe2.key)
$handle2 = connect-ucs -Key $key -LiteralPath C:\temp\cisco\ucspe2.xml


Get-UcsPSSession

Disconnect-Ucs -Ucs $handle2

Get-UcsPSSession



# 101 Basics
# Chassis Info
Get-UcsChassis

Get-UcsChassis | Format-Table 


# Blade Info
Get-UcsBlade

Get-UcsBlade | Format-Table

Get-UcsBlade | Format-Table DN, Model, NumofCPUs, NumofCores, TotalMemory 

Get-UcsChassis -Id 5 | Get-UcsBlade | Format-Table

Get-UcsChassis -Id 5 | Get-UcsBlade | Get-UcsAdaptorUnit | Format-Table

Get-UcsBlade | Format-List

(Get-UcsBlade).count


# Rack Info
Get-UcsRackUnit

Get-UcsRackUnit | Format-Table

Get-UcsRackUnit | Format-Table DN, Model, NumofCPUs, NumofCores, TotalMemory


# Get all servers regardless of form factor
Get-UcsServer | Format-Table


# Working with Orgs
Get-UcsOrg 

Add-UcsOrg -Name Ukoticland

Get-UcsOrg 

Remove-UcsOrg -Org Ukoticland

Add-UcsOrg -Name Ukoticland


# Service Profiles
Get-UcsServiceProfile

Add-UcsServiceProfile -Name MyFirstSP 

Get-UcsServiceProfile | Format-Table name

Remove-UcsServiceProfile -ServiceProfile MyFirstSP

Get-UcsServiceProfile | Format-Table name

Add-UcsServiceProfile -Name MyFirstSP


# Create SP from Template and associate Blade
$blade = Get-UcsBlade -Serial SRV83 
$ServiceProfile = Get-UcsServiceProfile -Name MyFirstSP
$DestOrg = Get-UcsOrg -Name Ukoticland
Add-UcsServiceProfileFromTemplate -NewName Production -ServiceProfile $ServiceProfile -DestinationOrg $DestOrg
Get-UcsServiceProfile -Name MyFirstSP | Connect-UcsServiceProfile -Blade $blade.ServerID 



# Get Faults
Get-UcsFault

Get-UcsFault | Format-Table

Get-UcsFault -Severity critical
Get-UcsFault -Severity major | Format-Table



# Backup and Import
Backup-Ucs -Type full-state -PathPattern C:\temp\cisco\ucspe-backup.tar.gz

Backup-Ucs -Type config-logical -PathPattern c:\temp\cisco\ucspe-config-logical.xml

Backup-Ucs -Type config-system -PathPattern c:\temp\cisco\ucspe-config-system.xml

Backup-Ucs -Type config-all -PathPattern 'c:\temp\cisco\ucspe-config-all.xml'

Backup-Ucs -Type config-all -PathPattern 'c:\temp\cisco\${ucs}-${yyyy}${MM}${dd}-${HH}${mm}-config-all.xml'

Import-UcsBackup -LiteralPath C:\temp\cisco\ucspe-config-all.xml -Merge


# Launch the Java Web UI
Start-UcsGuiSession



# Understanding Cmdlets
# Meta
Get-UcsCmdletMeta -ClassId fabricvlan
Get-UcsCmdletMeta -Noun UcsBlade

Get-UcsCmdletMeta -Noun ucsvlan -Tree


# Convert GUI Commands
ConvertTo-UcsCmdlet 








# Get-UcsLanCloud | Add-UcsVlan -CompressionType "included" -DefaultNet "no" -Id 18 -McastPolicyName "" -Name "18" -PolicyOwner "local" -PubNwName "" -Sharing "none"
