function Get-IbAPI {
    [CmdLetBinding()]
	param(
	[parameter(Mandatory=$true)]
	[string]$requestUrl,
	[Parameter(Mandatory=$true)]
    [pscredential]$Creds
	)
	
	$QueryResults = invoke-restMethod -uri $requestUrl -Method Get -ContentType "application/json" -credential $Creds -skipCertificateCheck
	return $QueryResults
}

function New-IBResource {
    [CmdLetBinding()]
	param(
	[parameter(Mandatory=$true)]
	[string]$requestUrl,
	[Parameter(Mandatory=$true)]
    [pscredential]$Creds,
	[parameter(Mandatory=$true)]
	[Object]$requestBody
	)
	
	$QueryResults = invoke-restMethod -uri $requestUrl -Method Post -ContentType "application/json" -credential $Creds -Body $requestBody -skipCertificateCheck
	return $QueryResults
}

function Get-IBCreds {
	# get the credentials for IB requests
	[CmdLetBinding()]
	param(
	[parameter(Mandatory=$true)]
	[string]$user,
	# vRO stores the password as a SecureString
	[Parameter(Mandatory=$true)]
	[string]$iBPassword
    # [pscredential]$Creds,
	# [parameter(Mandatory=$true)]
	# [Object]$requestBody
	)

	    # Credentials
		$password = ConvertTo-SecureString $iBPassword -AsPlainText -Force

		$iBCreds = New-Object Management.Automation.PSCredential ($user, $password)

		return $iBCreds

}
