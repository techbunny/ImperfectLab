Add-AzureRmAccount

Get-AzureRmSubscription

$VSSubID = "8bae2860-70c1-4614-b55a-60e97f4248dc"

Set-AzureRmContext -SubscriptionID $VSSubID

get-azurermresourcegroup | Format-Table ResourceGroupName, Location

Get-AzureRmVm -ResourceGroupName ImperfectLab | Format-Table Name

remove


#template variables

$assetLocation = "https://raw.githubusercontent.com/techbunny/ImperfectLab/master/" 
$templateFileURI  = $assetLocation + "imperfectlabdeploy.json" 
$parameterFileURI = $assetLocation + "imperfectlabdc01.parameters.json" 

$assetLocation = "https://raw.githubusercontent.com/techbunny/ImperfectLab/master/" 
$templateFileURI  = $assetLocation + "imperfectlabdeploy.json" 
$parameterFileURI = $assetLocation + "imperfectlabdc02.parameters.json" 


# Deploy the Template to the Resource Group

New-AzureRmResourceGroup -Name "ImperfectLab" -Location "West US"

New-AzureRmResourceGroupDeployment -ResourceGroupName "ImperfectLab" -TemplateURI $templateFileURI -TemplateParameterURI $parameterFileURI -Verbose

Get-AzureRmLog -Status Failed -ResourceGroup "ImperfectLab" -DetailedOutput 


#on management or gateway machine in CMD
winrm set winrm/config/client @{ TrustedHosts="13.88.16.207” }
winrm set winrm/config/


$ip = "104.40.54.0"
$ipAdministrator = "sysadmin"

#connect to target machine
$s = New-PSSession -ComputerName $ip -Credential $ipAdministrator
Enter-PSSession $s

#on Target Machine if not domain joined
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1

#or
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

$Name = "LocalAccountTokenFilterPolicy"

$value = "1"

New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null
Get-ItemProperty -Path $registryPath -Name $name


NETSH advfirewall firewall add rule name=WinRM5985 protocol=TCP dir=in localport=5985 action=allow
NETSH advfirewall firewall add rule name=WinRM5986 protocol=TCP dir=in localport=5986 action=allow

