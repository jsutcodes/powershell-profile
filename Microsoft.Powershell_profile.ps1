# Script: Microsoft.Powershell_profile.ps1
<# .SYNOPSIS
     powershell user configurations
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
#global
$profileDir = $PSScriptRoot;
# Basic Configuration:
#Set-PSDebug -Strict # This lets user not be able to use variables without declaring them
Set-PSReadlineOption -BellStyle None # Turn off annoying backspace noise
# Tab like it does in emacs/linux w/ autocomplete
Set-PSReadlineOption -EditMode Emacs 
Set-PSReadlineKeyHandler -Key Tab -Function Complete
# Change PowerShell Title to PowerShell and PowerShell Version
$Host.UI.RawUI.WindowTitle = "PowerShell {0}" -f $PSVersionTable.PSVersion.ToString()
# Change Title based on Admin
if ($isAdmin)
{
    $Host.UI.RawUI.WindowTitle += " [ADMIN]"
}


# Drive shortcuts
function HKLM:  { Set-Location HKLM: } # HKEY_LOCAL_MACHINE
function HKCU:  { Set-Location HKCU: } # HKEY_CURRENT_USER
function Env:   { Set-Location Env: }  # Enviroment Varables 

#################################################################################
# PowerShell Specific Commands
#################################################################################

function get-windows-build {
  [Environment]::OSVersion
}
# Special function powershell calls to display prompt
function prompt {
        $lastResult = Invoke-Expression '$?'
        if (!$lastResult) {
                Write-Host "Last command exited with error status." -ForegroundColor Red
        }
        Write-Output "${msg}$(
                # Show time as 12:05PM
                Get-Date -UFormat "%I:%M%p"
                # Show current directory
        ) $(Get-Location)> "  
}

#################################################################################
# Profile Specific Methods 
#################################################################################

# helper methods for powershell profile:
# Edit whole dir, so we can edit included files etc
function edit-powershell-profile {
  edit $profileDir # edit is defined in default.ps1
}

function update-powershell-profile {
  & $profile
}

function admin
{
    if ($args.Count -gt 0)
    {   
       $argList = "& '" + $args + "'"
       Start-Process "$psHome\powershell.exe" -Verb runAs -ArgumentList $argList
    }
    else
    {
       Start-Process "$psHome\powershell.exe" -Verb runAs
    }
}

#################################################################################
# Aliases
#################################################################################

# Set UNIX-like aliases for the admin command, so sudo <command> will run the command
# with elevated rights. 
Set-Alias -Name su -Value admin
Set-Alias -Name sudo -Value admin



# TODO: Changes i'd like: 
# vim integration in default.ps1
# head command 




#################################################################################
# Import-Module (If this section grows to large could include modules.ps1)
#################################################################################
 Import-Module posh-git


#################################################################################
# Load other ps1 scripts
#################################################################################
# USe this to load other ps1 files inot profile 
foreach ( $includeFile in ("default", "linux", "development") ) {
  Unblock-File $profileDir\$includeFile.ps1
. "$profileDir\$includeFile.ps1"
}
write-output "Jordan profile loaded from: $PSScriptRoot"
