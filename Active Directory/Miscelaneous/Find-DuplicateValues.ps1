<#
.SYNOPSIS
Find objects with duplicate values across multiple
attributes.

.DESCRIPTION
This script can be used to find multiple objects in a
forest that contain duplicate values.  

Object types searched:
- user
- group
- contact

Default Attributes searched:
- userPrincipalName
- mail

Exchange Attributes searched:
- proxyAddresses
- targetAddress

SIP Attributes searched:
- msRTCSIP-PrimaryUserAddress

.PARAMETER Address
Object address expressed as a userPrincipalName or
email address.

.PARAMETER Autodetect
Detect which schema classes to query automatically.

.PARAMETER Credential
Optionally specify a credential to be used.

.PARAMETER IncludeExchange
Include Exchange attributes (must have Active Directory 
schema extended for Exchange).

.PARAMETER IncludeSIP
Include SIP attributes (must have Active Directory schema
extended for a SIP product, such as Live Communications
Server, Office Communications Server, Lync Server, or
Skype for Business Server).

.PARAMETER LDAPStyle
Perform older LDAPFilter style matching (which will include
partial matches.

.PARAMETER OutputColor
Specify output color for match highlighting.

.EXAMPLE
.\Find-DuplicateValues.ps1 -Credential (Get-Credential) -Address john@contoso.com -IncludeExchange
Prompt for credentials and search all domains in forest for default and Exchange attributes that contain john@contoso.com.

.EXAMPLE
.\Find-DuplicateValues.ps1 -Address john@contoso.com -IncludeExchange -IncludeSIP
Search all domains in forest for default, Exchange, and SIP attributes that contain john@contoso.com.

.EXAMPLE
.\Find-DuplicateValues.ps1 -Credential $cred -Address john@contoso.com -IncludeSIP
Search all domains in forest for default and SIP attributes using saved credential object $cred.

.LINK
https://gallery.technet.microsoft.com/Find-Duplicate-Values-in-6b012059

.NOTES

2018-04-16 - Update to search for duplicate x500 patterns.
		   - Update to perform better in large environments.
2016-10-26 - Update for $FormatEnumeration parameter.
2016-10-17 - The output now highlights the matching values, making it easier to locate conflicting attributes
			 - Detect if schema contains SIP and Exchange attributes
			 - Due to an issue with Partial Matching, replaced -LDAPFilter with -Filter parameter.  
			 The original -LDAPFilter syntax is still available if you want to do partial matching 
			 via the new -LDAPStyle parameter.
2016-10-01 - Original release.

All envrionments perform differently. Please test this code before using it
in production.

THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY 
OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF 
THIS CODE REMAINS WITH THE USER.

Author: Aaron Guilmette
		aaron.guilmette@microsoft.com
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true,Position=0,HelpMessage='Object address to search for, in the form of user@domain.com')]
        [string]$Address,
	[Parameter(Mandatory=$false,HelpMessage='Autodetect schema classes')]
        [switch]$AutoDetect = $true,
    [Parameter(Mandatory=$false,HelpMessage='Credential')]
		[object]$Credential,
	[array]$Domains,
    [Parameter(Mandatory=$false,HelpMessage='Include Exchange Attributes')]
        [switch]$IncludeExchange,
    [Parameter(Mandatory=$false,HelpMessage='Include RTC attributes (Live Communications Server, Office Communications Server, Lync, Skype')]
        [switch]$IncludeSIP,
    [Parameter(Mandatory=$false,HelpMessage='Specify output color')]
        [ValidateSet("Black","DarkBlue","DarkGreen","DarkCyan","DarkRed","DarkMagenta","DarkYellow","Gray","DarkGray","Blue","Green","Cyan","Red","Magenta","Yellow","White")]        
        [string]$OutputColor = "Cyan",
    [Parameter(Mandatory=$false,HelpMessage='LDAP Style--will result in partial matches')]
        [switch]$LDAPStyle
	)

filter FormatColor {
    param(
        [string] $StringMatch,
        [string] $HighlightColor = $OutputColor
    )
    $line = $_
    $index = $line.IndexOf($StringMatch, [System.StringComparison]::InvariantCultureIgnoreCase)
    while($index -ge 0){
        Write-Host $line.Substring(0,$index) -NoNewline
        Write-Host $line.Substring($index, $StringMatch.Length) -NoNewline -ForegroundColor $OutputColor
        $used = $StringMatch.Length + $index
        $remain = $line.Length - $used
        $line = $line.Substring($used, $remain)
        $index = $line.IndexOf($StringMatch, [System.StringComparison]::InvariantCultureIgnoreCase)
    }
    Write-Host $line
}

# Check for Active Directory module
If (!(Get-Module ActiveDirectory))
	{
	Import-Module ActiveDirectory
	}

If ($AutoDetect)
    {
    $schema = [directoryservices.activedirectory.activedirectoryschema]::getcurrentschema()
    $ExchTest = $schema.FindClass("user").OptionalProperties | ? { $_.Name -match "msExchRecipientTypeDetails" }
    $SIPTest = $schema.FindClass("user").OptionalProperties | ? { $_.Name -match "msRTCSIP-PrimaryUserAddress" }
    If ($ExchTest) { $IncludeExchange = $true ; Write-Host "Found Exchange Attributes."}
    If ($SIPTest) { $IncludeSIP = $true; Write-Host "Found SIP Attributes." }
    }

If (!$Domains) { [array]$Forests = (Get-ADForest).Domains }
Else { $Forests = $Domains }
[array]$Attributes = @("UserPrincipalName","DisplayName","DistinguishedName","objectClass","mail")

$global:FormatEnumerationLimit = -1

# Add Additional Arrays together
If ($IncludeExchange)
    {
    $ExchangeAttributes = @("proxyAddresses","msExchRecipientDisplayType","msExchRecipientTypeDetails","mailnickname","targetAddress")
    $Attributes += $ExchangeAttributes
    }
If ($IncludeSIP)
    {
    $SIPAttributes = @("msRTCSIP-PrimaryUserAddress")
    $Attributes += $SIPAttributes
    }

If ($LDAPStyle)
    {
    # Build LDAP Filter
    [string]$LDAPFilter = "(&(|(objectClass=user)(objectClass=group)(objectClass=contact))(|(userprincipalname=$address)(mail=*$address)))"

    If ($IncludeExchange)
        {
        $LDAPFilter = $LDAPFilter.Substring(0,$LDAPFilter.Length -2) + "(proxyaddresses=*$address)(targetaddress=smtp:$address)))"
        }

    If ($IncludeSIP)
        {
        $LDAPFilter = $LDAPFilter.Substring(0,$LDAPFilter.Length -2) + "(msRTCSIP-PrimaryUserAddress=*$address)))"
        }

    If ($Credential)
        {
        Foreach ($Domain in $Forests) 
            {
	        Write-Host -ForegroundColor Yellow "Searching $Domain for $address"
            Get-AdObject -Credential $Credential -Server $Domain -LDAPFilter $LDAPFilter -Properties $Attributes| Select $Attributes | Out-String | FormatColor -StringMatch $($address) -HighlightColor $($Color)
    	    }
        }
    Else
        {
        Foreach ($Domain in $Forests) 
            {
	        Write-Host -ForegroundColor Yellow "Searching $Domain for $address"
            Get-AdObject -Server $Domain -LDAPFilter $LDAPFilter -Properties $Attributes| Select $Attributes | Out-String | FormatColor -StringMatch $($address) -HighlightColor $($Color)
   	        }
        }
    }
Else
    {
    $Filter = [scriptblock]::Create("`{ UserPrincipalName -eq `"$address`" -or mail -eq `"$address`" `}")
	
	If ($Address -match "@")
	{
		If ($IncludeExchange)
		{
			$Filter = [scriptblock]::Create("`{ Userprincipalname -eq `"$address`" -or mail -eq `"$address`" -or proxyAddresses -like `"`*`:$address`" `}")
		}
		If ($IncludeSIP)
		{
			$Filter = [scriptblock]::Create("`{ Userprincipalname -eq `"$address`" -or mail -eq `"$address`" -or msRTCSIP-PrimaryUserAddress -like `"`*`:$address`" `}")
		}
		If ($IncludeExchange -and $IncludeSIP)
		{
			$Filter = [scriptblock]::Create("`{ Userprincipalname -eq `"$address`" -or mail -eq `"$address`" -or msRTCSIP-PrimaryUserAddress -like `"`*`:$address`" -or proxyAddresses -like `"`*`:$address`" `}")
		}
	}
	if ($Address -like "*x500:*")
	{
		$Filter = [scriptblock]::Create("`{proxyaddresses -like `'*$($Address)`*' `}")
	}
	
	Foreach ($Domain in $Forests)
        {
		$Properties = $Attributes -join ","
		If ($Credential)
            {
            $cmd = "Get-ADObject -Credential `$Credential -Server $Domain -Filter $Filter -Properties $($Properties) | Out-String | FormatColor -StringMatch `"$($address)`" -HighlightColor `$($Color)"
            }
        Else
            {
            $cmd = "Get-ADObject -Server $Domain -Filter $Filter -Properties $($Properties) | Out-String | FormatColor -StringMatch `"$($address)`" -HighlightColor `$($Color)"
            }
        Write-Host -ForegroundColor Yellow "Searching $Domain for $address"
		#Write-Host Command is:
		#Write-Host -fore Yellow $cmd
		Invoke-Expression $cmd
        }
    }
