# Script to request the next available subnet from an InfoBlox network Container.

$ScriptPath = Split-Path $MyInvocation.MyCommand.Path

# import InfoBlox.psm1
Import-Module $ScriptPath\Modules\InfoBlox.psm1

function Handler($context, $inputs) {
        try{

        $ibApiUrl= $inputs.infobloxApiEndpoint # String

        $user = $inputs.infobloxUser # String

        $password = $inputs.infobloxPassword # SecureString

        $infobloxNetworkContainer = $inputs.infobloxNetworkContainer # String
    
        $infobloxSubnetPrefix = $inputs.infobloxSubnetPrefix # String

        $infobloxNetworkView = $inputs.infobloxNetworkView # String

        $enableDebug = $inputs.enableDebug # Boolean
    
        if ($enableDebug -eq $true) {
            Write-Host "***** Input variables *****"
            write-host "InfobloxApiEndpoint $ibApiUrl"
            Write-host "infobloxUser $user"
            Write-Host "infobloxNetworkContainer $infobloxNetworkContainer "
            Write-Host "infobloxSubnetPrefix $infobloxSubnetPrefix"
            Write-Host "infobloxNetworkView $infobloxNetworkView"
        }
        # Credentials
        $password = ConvertTo-SecureString $inputs.infobloxPassword -AsPlainText -Force

        $iBCreds = New-Object Management.Automation.PSCredential ($user, $password)
        # Wonky concatination in vRO will not append $infobloxNetworkContainer 
        # workaround 
        $networkBody = "func:nextavailablenetwork:"
        $networkBody += $infobloxNetworkContainer + ","
        $networkBody += $infobloxNetworkView + ","
        $networkBody += $infobloxSubnetPrefix

        if ($enableDebug -eq $true) {Write-host $networkBody}

        $body = @{
            "network" = $networkBody
            "network_view" = "$infobloxNetworkView"
        } | ConvertTo-Json
        
        if ($enableDebug -eq $true) {Write-host $body}
    
        $requestUrl = $inputs.infobloxApiEndpoint + "network?_return_fields=network&_return_as_object=1"
        
        if ($enableDebug -eq $true) {Write-host "network request url $requestUrl"}

        $requestResponse = New-IBResource $requestUrl $iBCreds $body

        if ($requestResponse.length -lt 1) {
            throw "A subnet was not created."
        }
        else {
            if ($enableDebug -eq $true) {
                Write-host "The new IB CIDR is " $requestResponse.result.network
                Write-host "The new IB subnet ref " $requestResponse.result._ref
            }
            # output Properties
            # Need the subnetRef
            $output = @{"newSubnetCidr" = $requestResponse.result.network; "newSubnetRef" = $requestResponse.result._ref}

            # $output = $requestResponse.result.network

            if ($enableDebug -eq $true) {Write-Host "The output should be " $output | ConvertTo-Json}
        }

        # return Properties
        return $output 
    }
    catch {
        $PSCmdLet.ThrowTerminatingError($PSItem)
    }

}