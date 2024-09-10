$key = (1..16).ForEach{[byte](Get-Random -Minimum 0 -Maximum 256)}
$userPasswd = (get-credential).Password
$encryptedPassword = $userPasswd | convertFrom-securestring -Key $key

$key | set-content ".\ada.bin"
$encryptedPassword | set-content ".\ada.txt"

