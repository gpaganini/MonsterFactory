[CmdletBinding()]
param (
    [switch]$Offboard,
    [string]$User
)

if ($Offboard) {
    echo test
}