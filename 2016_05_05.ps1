Add-AzureRmAccount

Get-AzureRmSubscription

$VSSubID = "8bae2860-70c1-4614-b55a-60e97f4248dc"

Set-AzureRmContext -SubscriptionID $VSSubID

get-azurermresourcegroup | Format-Table ResourceGroupName, Location

Get-AzureRmVm -ResourceGroupName SmallCloudLab | Format-Table Name

#cleanup 

Remove-AzureRmResourceGroup -Name NanoNano
Remove-AzureRmResourceGroup -Name NanoNano2
Remove-AzureRmResourceGroup -Name NanoNano3
Remove-AzureRmResourceGroup -Name RecoverHere
Remove-AzureRmResourceGroup -Name SmallCloudLab

#template variables

$assetLocation = "https://raw.githubusercontent.com/techbunny/Templates/master/smallcloudlab/" 
$templateFileURI  = $assetLocation + "smalllabdeploy_nsg.json" 
$parameterFileURI = $assetLocation + "azuredeploy.parameters.json" 


# Deploy the Template to the Resource Group

New-AzureRmResourceGroup -Name "SmallCloudLab" -Location "West US"

New-AzureRmResourceGroupDeployment -ResourceGroupName 'SmallCloudLab' -TemplateURI $templateFileURI -ParameterFileURI $parameterFileURI -Verbose

Get-AzureRmLog -Status Failed -ResourceGroup "SmallCloudLab" -DetailedOutput 




#on gateway machine
winrm set winrm/config/client @{ TrustedHosts="40.76.47.200” }
winrm set winrm/config/


$ip = "104.40.93.91"
$ipAdministrator = "sysadmin"

#connect to target machine
$s = New-PSSession -ComputerName $ip -Credential $ipAdministrator
Enter-PSSession $s

#on Target Machine
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1


$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

$Name = "LocalAccountTokenFilterPolicy"

$value = "1"

New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null
Get-ItemProperty -Path $registryPath -Name $name


NETSH advfirewall firewall add rule name=WinRM5985 protocol=TCP dir=in localport=5985 action=allow
NETSH advfirewall firewall add rule name=WinRM5986 protocol=TCP dir=in localport=5986 action=allow

