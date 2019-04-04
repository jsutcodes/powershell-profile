# Script: default.ps1
<# .SYNOPSIS
     powershell user configurations [default]
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

#################################################################################
# Methods Specific to user 
#################################################################################

# asks for app to setup 
# function settings {
#   start-process ms-setttings:
# }
# Opens the default text editor 
function edit($file) {

}

# http://mohundro.com/blog/2009/03/31/quickly-extract-files-with-powershell/
# and https://stackoverflow.com/questions/1359793/programmatically-extract-tar-gz-in-a-single-step-on-windows-with-7zip
#need 7z as a dependency!!!!1
function expand-archive([string]$file, [string]$outputDir = '') { 
  if (-not (Test-Path $file)) {
    $file = Resolve-Path $file
  }

  $baseName = get-childitem $file | select-object -ExpandProperty "BaseName"

  if ($outputDir -eq '') {
    $outputDir = $baseName
  }

  # Check if there's a tar inside
  # We use the .net method as this file (x.tar) doesn't exist!
  $secondExtension = [System.IO.Path]::GetExtension($baseName)
  $secondBaseName = [System.IO.Path]::GetFileNameWithoutExtension($baseName)

  if ( $secondExtension -eq '.tar' ) {
    # This is a tarball
    $outputDir = $secondBaseName
    write-output "Output dir will be $outputDir"    
    7z x $file -so | 7z x -aoa -si -ttar -o"$outputDir"
    return
  } 
  # Just extract the file
  7z x "-o$outputDir" $file 
}

function get-path {
  ($Env:Path).Split(";")
}


function get-process-for-port($port) {
  Get-Process -Id (Get-NetTCPConnection -LocalPort $port).OwningProcess
}

function get-serial-number {
  Get-CimInstance -ClassName Win32_Bios | select-object serialnumber
}

function reboot {
  $rebootNow = Read-Host -Prompt 'Are you sure you would like to shutdown (y or yes)?'

  if($rebootNow -eq "y" -Or $rebootNow -eq "yes") {
    Write-Host "Restarting now..."
    shutdown /r /t 0
  }
}

# https://blogs.technet.microsoft.com/heyscriptingguy/2012/12/30/powertip-change-the-powershell-console-title
function set-title([string]$newtitle) {
  $host.ui.RawUI.WindowTitle = $newtitle + ' – ' + $host.ui.RawUI.WindowTitle
}

function shutdown-now {

 $shutdownNow = Read-Host -Prompt 'Are you sure you would like to shutdown (y or yes)?'

  if($shutdownNow -eq "y" -Or $shutdownNow -eq "yes") {
    Write-Host "Shutting down now..."
    Stop-Computer
  }
}

function uptime {
  Get-CimInstance Win32_OperatingSystem | select-object csname, @{LABEL='LastBootUpTime';
  EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}
}


#################################################################################
# Aliases
#################################################################################
set-alias extract expand-archive
set-alias unzip expand-archive
# function regedit-search {}
# function regedit-search {
# get-childitem -path hkcu:\ -recurse -ErrorAction SilentlyContinue | Where-Object {$_.Name -like "*Netwrix*"}
#   https://blog.netwrix.com/2018/09/11/how-to-get-edit-create-and-delete-registry-keys-with-powershell/
# }


write-output 'default.ps1 loaded.'