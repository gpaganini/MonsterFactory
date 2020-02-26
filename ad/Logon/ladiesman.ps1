<# Define clear text password
[string]$userPassword = ''

# Crete credential Object
[SecureString]$secureString = $userPassword | ConvertTo-SecureString -AsPlainText -Force 

# Get content of the string
[string]$stringObject = ConvertFrom-SecureString

# Save Content to file
$stringObject | Set-Content -Path '.\ladiesman.txt'#>

"" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File "ladiesman.txt"