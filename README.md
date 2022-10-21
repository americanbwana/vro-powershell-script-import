# Import a zipped PowerShell action into vRealize Orchestrator

## Use
* Clone the repo
* Zip up the file with zip -r -x ".git/*" -x "README.md" -X nextibsubnet.zip .
* Upload into vRO
* Add in action inputs
* Change the return type to Properties
* Enter 'getNextAvailableIbSubnet.handler' in under 'Entry Handler'
* Fire away

### For more info
https://knotacoder.com/2022/10/21/vro-action-powershell-zip-importing-and-use/