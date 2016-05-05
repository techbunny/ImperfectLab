#INSTALL AD FOREST
Add-WindowsFeature -name ad-domain-services -IncludeManagementTools
Install-ADDSForest -DomainName "imperfectlab.com" -ForestMode 5 -DomainMode 5

#Functional Levels
2003 = 2
2008 = 3
2008R2 = 4
2012 = 5


# Add Domain Controller
Add-WindowsFeature AD-Domain-Services
Install-ADDSDomainController -Credential (Get-Credential) -DatabasePath 'C:\Windows\NTDS' -DomainName 'imperfectlab.com' -InstallDns:$true -LogPath 'C:\Windows\NTDS' -NoGlobalCatalog:$false -SiteName 'AnotherNet' -SysvolPath 'C:\Windows\SYSVOL' -NoRebootOnCompletion:$true -Force:$true -Verbose
Install-ADDSDomainController -Credential (Get-Credential) -DatabasePath 'C:\Windows\NTDS' -DomainName 'imperfectlab.com' -InstallDns:$true -LogPath 'C:\Windows\NTDS' -NoGlobalCatalog:$false -SiteName 'ImperfectNet' -SysvolPath 'C:\Windows\SYSVOL' -NoRebootOnCompletion:$true -Force:$true -Verbose
