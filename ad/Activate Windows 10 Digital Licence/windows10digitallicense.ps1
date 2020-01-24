# Get windows 10 digital license
# Author Robert Smit
# Twitter @clusterMVP
# Blog : https://robertsmit.wordpress.com/
# Date March 8, 2017
# Version 1.0
Set-ExecutionPolicy Unrestricted
$service = get-wmiObject -query 'select * from SoftwareLicensingService'
$service.OA3xOriginalProductKey
$key=$service.OA3xOriginalProductKey
$service.InstallProductKey($key)

$service = get-wmiObject -query 'select * from SoftwareLicensingService'
if($key = $service.OA3xOriginalProductKey){
	Write-Host 'Activating using product Key:' $service.OA3xOriginalProductKey
	$service.InstallProductKey($key)
}else{

	Write-Host 'Key not found., use a different license'
        $service.InstallProductKey('Put your License KEY here')
}