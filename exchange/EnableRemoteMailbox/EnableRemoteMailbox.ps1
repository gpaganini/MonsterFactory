# todo
[cmdletbinding()]
param
(
	[Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
	[alias('DestUser')]
	[String[]]$DestinationUsers
Begin
{
	
}

