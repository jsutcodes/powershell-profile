# Script: development.ps1
<# .SYNOPSIS
     powershell user configurations [development]
.DESCRIPTION
     Main use is to make Powershell feel more like linux
.NOTES
     Jordan     : Jordan Sutton <jsutcodes@gmail.com>
     Version    : 1.0
     
    This file should be stored in $PROFILE.CurrentUserAllHosts
    If $PROFILE.CurrentUserAllHosts doesn't exist, you can make one with the following:
        PS> New-Item $PROFILE.CurrentUserAllHosts -ItemType File -Force
    This will create the file and the containing subdirectory if it doesn't already 

    As a reminder, to enable unsigned script execution of local scripts on client Windows, 
    you need to run this line (or similar) from an elevated PowerShell prompt:
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
    This is the default policy on Windows Server 2012 R2 and above for server Windows. For 
    more information about execution policies, run Get-Help about_Execution_Policies.
    Find out if the current user identity is elevated (has admin rights)
.LINK
    taken from  : https://github.com/mikemaccana/powershell-profile notes here 
#>

#Vim
#git

write-output 'development.ps1 loaded.'